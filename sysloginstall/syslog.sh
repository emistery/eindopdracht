#!/bin/bash
# Made by Emiel Kok
# Script to install Syslog-NG

sudo wget -qO - http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_17.04/Release.key | sudo apt-key add -

sudo touch /etc/apt/sources.list.d/syslog-ng-obs.list

echo 'deb http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/xUbuntu_17.04 ./' >> /etc/apt/sources.list.d/syslog-ng-obs.list

sudo apt-get update

sudo apt-get install syslog-ng-core
