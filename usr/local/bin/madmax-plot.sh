#!/bin/bash

# Variables 
POOLKEY="a0226aee1c59ba9a70f9c4aab77ea662bce96766b58913dfff2fb48c5766d594d0430b38df7b5f9f1787d39d7ab310f6"
FARMERKEY="9425d29b05b659d05814cd989e0d976c9b755f9730d3e112c8609aa3d5dd250a86ecb8c164a66861857d45e71d6c9b9a"
THREADS=20
DESTINATION="/r0zfs1/"

telegram-send "Starting MadMax Chia Plotter on ${HOSTNAME}"

# Clear the Plotting Disk Before Start
rm -f /mnt/plot/*

# Loop Until Disk Full
while true
do
    # Get Available Space on Destination Disk
    AVAIL=$(df --output=avail ${DESTINATION} | grep -v Avail)

    # Check Space on Destination
    if [ $AVAIL -lt 115000000 ]; then 
        telegram-send "${HOSTNAME} Out of Disk Space on ${DESTINATION}. Stopping Plotting!"

        # Stop Plotter Service
        systemctl stop plotter
    fi

    # Sleep For 10 Seconds
    sleep 10
    
    # Create Plot with 29 Threads (Pool-Key Farmer-Key PlotDir PlotDir Threads[4] Buckets[7])
    chia_plot -p ${POOLKEY} -f ${FARMERKEY} -t /mnt/plot/ -2 /mnt/plot/ -r ${THREADS} -u 7 >> /var/log/chia-plotter/plotter.log

    # Sleep For 10 Seconds
    sleep 10

    # Copy Plot to Destination Disk & Delete Plot on NVME When Copied
    #rsync -v --remove-source-files --log-file=/var/log/chia-plotter/rsync.log --info=progress2 /mnt/plot/*.plot ${DESTINATION} 

    telegram-send "Completed a Chia Plot on ${HOSTNAME}"
done
