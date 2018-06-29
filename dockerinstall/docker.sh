#!/bin/sh
#Made by Emiel Kok
#Script to automatically install Docker CE

echo "Installing prerequisites"

sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get install ca-certificates
sudo apt-get install curl
sudo apt-get install software-properties-common

echo "Prerequisites are installed!"

echo "Adding GPG key"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "GPG key is added!"

echo "Adding APT repository"

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "repository has been added!"

echo "Installing docker"

sudo apt-get update
sudo apt-get install docker-ce

echo "Docker is installed!"

echo "Running a quick test. Check to see if docker has been installed successfully"

sudo docker run hello-world
