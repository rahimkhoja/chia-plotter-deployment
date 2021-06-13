# Create Logging Directory
mkdir -p /var/log/chia-plotter || true
chmod -R 777 /var/log/chia-plotter

# Install Telegram-Send
pip3 install telegram-send

# Remove Old Install
rm -f /usr/local/bin/madmax-plot.sh
rm -f /etc/systemd/system/plotter.service
rm -rf /usr/share/chia-plotter

# Install Plotter Service
cp usr/local/bin/madmax-plot.sh /usr/local/bin/
chmod +x /usr/local/bin/madmax-plot.sh
cp etc/systemd/system/plotter.service /etc/systemd/system/


# Setup and Compile MadMax Chia Plotter
cd /usr/share
git clone https://github.com/madMAx43v3r/chia-plotter.git
cd /usr/share/chia-plotter
git submodule update --init
bash ./make_devel.sh
cp /usr/share/chia-plotter/build/chia_plot /usr/bin/

# Reload Systemd Daemons
systemctl daemon-reload

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
