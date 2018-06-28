#!/bin/sh
# Mady by Emiel Kok
# Script to install nagios server

echo "Installing Nagios!"
#adding user and group for nagios
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagios,nagcmd www-data

#updating and install prerequisites
sudo apt-get update
sudo apt-get install build-essential libgd2-xpm-dev openssl libssl-dev unzip


#downloading nagios and extracting
cd ~
curl -L -O https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.4.tar.gz
tar zxf nagios-4.3.4.tar.gz

#configure user and group
cd nagios-4.3.4.tar.gz
./configure --with-nagios-group=nagios --with-command-group=nagcmd

#compiling nagios
sudo make all
sudo make install
sudo make install-commandmode
sudo make install-init
sudo make install-config

#copying apache file
sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.confsudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

echo "Nagios is installed"

echo "Installing NRPE plugin"

#download NRPE plugin
cd ~
curl -L -O https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
tar zxf nrpe-3.2.1.tar.gz

#Configure NRPE plugin
cd nrpe-3.2.1.tar.gz
./configure

#compile NRPE
sudo make check_nrpe
sudo make install-plugin

#installing plugins and changing check files
#sudo apt-get install nagios-plugins
#cp /usr/lib/nagios/plugins/check_* /usr/local/nagios/libexec

echo "NRPE Plugin is installed!"

echo "Configuring Nagios!"

#Finish the configuration

#uncommenting line in config file
sed -i '/cfg_dir/s/^#//g' /usr/local/nagios/etc/nagios.cfg

#Creating dir for each monitored servers config
sudo mkdir /usr/local/nagios/etc/servers

#Inserting nrpe command
cat <<EOT >> /usr/local/nagios/etc/objects/commands.cfg
define command{
        command_name check_nrpe
        command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}
EOT

#enabling apache modules
sudo a2enmod rewrite
sudo a2enmod cgi

echo "Choose admin password!"

sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

#creating symbolic link for apache site
sudo ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/

#restarting apache to process changes
sudo systemctl restart apache2

#creating systemd file
cat <<EOT >> /etc/systemd/system/nagios.service
[Unit]
Description=Nagios
BindTo=network.target

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
User=nagios
Group=nagios
ExecStart=/usr/local/nagios/bin/nagios /usr/local/nagios/etc/nagios.cfg
EOT

#enabling nagios on system boot
sudo systemctl enable /etc/systemd/system/nagios.service
sudo systemctl start nagios

echo "Thank you for your patience, nagios is installed!"


