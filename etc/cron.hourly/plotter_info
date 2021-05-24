#!/bin/bash
TotalPlots=$(tail -n 100 /var/log/chia/chia.log | grep chia.plotting.plot_tools | sort -r | head -n 1 | awk '{ print $9 }')
TotalDiskSpace=$(tail -n 100 /var/log/chia/chia.log | grep chia.plotting.plot_tools | sort -r | head -n 1 | awk '{ print $13 " " $14 }' | sed 's/.$//')
echo "Total Plots on $(hostname): ${TotalPlots} - Total Space Used for Plots: ${TotalDiskSpace}"
telegram-send "Total Plots on $(hostname): ${TotalPlots} - Total Space Used for Plots: ${TotalDiskSpace}"
