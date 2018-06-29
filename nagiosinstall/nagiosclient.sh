#!/bin/sh

IPADDR="$1"

sudo useradd nagios
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get install libgd2-xpm-dev
sudo apt-get install openssl
sudo apt-get install libssl-dev
sudo apt-get install unzip

cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar zxf nagios-plugins-2.2.1.tar.gz
cd nagios-plugins-2.2.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
sudo make
sudo make install

cd ~
curl -L -O https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
tar zxf nrpe-3.2.1.tar.gz
cd nrpe-3.2.1
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
sudo make all
sudo make install
sudo make install-config
sudo make install-init
#Hardcoded IP address, change this to your nagios master IP
sed  -e '/allowed_hosts/s/$/,10.0.2.5/' /usr/local/nagios/etc/nrpe.cfg

sudo systemctl start nrpe.service
sudo systemctl status nrpe.service

sudo ufw allow 5666/tcp  
