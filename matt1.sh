# Reload Systemd Daemons
systemctl daemon-reload

# Enable FSTrim Service
systemctl enable fstrim.timer

# Enable Plotter Service
systemctl enable plotter.service

num_cpus=$(nproc)

echo
echo "Deployment Successful"
echo
echo "You Have ${num_cpus} Threads Available for Plotting"
echo
echo "Please Edit /usr/local/bin/madmax-plot.sh and Add Your Farmer Key, Your Pool Key, and the Threads to be used by the Plotter"
echo
echo "Reboot to start Auto Plotting"

# Re-enable GUI for Matt
sudo systemctl set-default graphical
