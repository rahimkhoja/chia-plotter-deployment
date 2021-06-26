#!/bin/bash
telegram-send "Restarting HPool Miner on ${HOSTNAME}"
systemctl stop hpool.service

# Stop Plotter Service. Sometimes HPOOL Does Not Start (Yes you may loose the current plot)
systemctl stop plotter.service

# Ping Hpool.com and Hpool.co to ensure DNS Resolution (I think this may also be part of the HPool restart Issue)
ping -c 5 hpool.com
ping -c 5 hpool.co

systemctl start hpool.service

# Wait for 2 minutes
sleep 120

# Restart Plotter Service
systemctl start plotter.service
