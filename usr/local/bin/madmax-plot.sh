#!/bin/bash

while true
do
    # Sleep For 10 Seconds
    sleep 10
    
    # Create Plot with 29 Threads (Pool-Key Farmer-Key PlotDir PlotDir Threads[4] Buckets[7])
    chia_plot a0226aee1c59ba9a70f9c4aab77ea662bce96766b58913dfff2fb48c5766d594d0430b38df7b5f9f1787d39d7ab310f6 9425d29b05b659d05814cd989e0d976c9b755f9730d3e112c8609aa3d5dd250a86ecb8c164a66861857d45e71d6c9b9a /mnt/plot/ /mnt/plot/ 28 8 2>&1 /var/log/chia-plotter/plotter.log

    # Sleep For 10 Seconds
    sleep 10

    # Copy Plot to ZFS Disk & Delete Plot on NVME When Copied
    rsync -v --remove-source-files --info=progress2 /mnt/plot/*.plot /r0zfs1/ 2>&1 /var/log/chia-plotter/plotter.log
done