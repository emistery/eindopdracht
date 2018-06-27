#!/bin/sh
# Made by Emiel Kok
# Script om salt clients te accepteren

sudo salt-key --list-all
sudo salt-key --accept-all
echo "Alle clients zijn toegevoegd!"
