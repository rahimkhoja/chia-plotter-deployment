#!/bin/bash

# Variables (Update These Two Lines)
POOLKEY="a0226aee1c59ba9a70f9c4aab77ea662bce96766b58913dfff2fb48c5766d594d0430b38df7b5f9f1787d39d7ab310f6"
FARMERKEY="9425d29b05b659d05814cd989e0d976c9b755f9730d3e112c8609aa3d5dd250a86ecb8c164a66861857d45e71d6c9b9a"

# Threads to save for System Processing (Hpool or Harvestor) [Advanced. Probably doesn't need to be updated]
FREETHREADS=2 

# Destination Disk Mount Points. If only one disk , you only need one element. (I have 11 disks as destinations)
declare -a DESTINATIONARR=("/r0zfs1/" "/r0zfs2/" "/r0zfs3/" "/r0zfs4/" "/r0zfs5/" "/r0zfs6/" "/r0zfs7/" "/r0zfs8/" "/r0zfs9/" "/r0zfs10/" "/r0zfs11/")

# Discover Total Threads
TOTALTHREADS=$(nproc)

# Subtract FREETHREADS from TOTALTHREADS
THREADS=$((TOTALTHREADS-FREETHREADS))

# Start Plotting Message
telegram-send "Starting MadMax Chia Plotter on ${HOSTNAME} with ${THREADS} Threads."

# Clear the Plotting Disk Before Start
rm -f /mnt/plot/*

DESTINATION=""

# Loop Until Disk Full
while true
do

    for i in "${DESTINATIONARR[@]}"
    do

       # Get Available Space on Destination Disk
       AVAIL=$(df --output=avail ${i} | grep -v Avail)

       # Check Space
       if [ $AVAIL -gt 114000000 ]; then
           
           if [ "${i}" != "$DESTINATION" ]; then
               telegram-send "${HOSTNAME} Selecting Disk ${i}."
           fi

           # Define Destination Disk
           DESTINATION="${i}"
           break
       fi
 
       # Stop Plotter Service if Last Disk
       if [ "${DESTINATIONARR[-1]}" = "${i}" ]; then

           telegram-send "${HOSTNAME} Out of Disk Space on ${DESTINATION}. No Space on System. Stopping Plotting!"

           # Sleep For 5 Seconds
           sleep 5

           # Stop Plotter Service
           systemctl stop plotter      
       fi
    
    done
    
    # Sleep For 10 Seconds
    sleep 10

    # Create Plot with 29 Threads (Pool-Key Farmer-Key PlotDir PlotDir Threads[4] Buckets[7])
    chia_plot -p ${POOLKEY} -f ${FARMERKEY} -t /mnt/plot/ -2 /mnt/plot/ -r ${THREADS} -u 7 >> /var/log/chia-plotter/plotter.log
     
    # Sleep For 10 Seconds
    sleep 10

    # Copy Plot to Destination Disk & Delete Plot on NVME When Copied
    rsync -v --remove-source-files --log-file=/var/log/chia-plotter/rsync.log --info=progress2 /mnt/plot/*.plot ${DESTINATION}

    telegram-send "Completed a Chia Plot on ${HOSTNAME}"
done
