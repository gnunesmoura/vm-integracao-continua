#!/bin/bash
sudo apt-get -q update 
sudo apt-get -q upgrade -y
sudo apt-get -q install -y --install-recommends linux-generic-lts-xenial 
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536
sudo apt-get -q install git unzip -y

wget -q -P ./ "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.0.0.1744-linux.zip"
unzip -q sonar-scanner-cli-4.0.0.1744-linux.zip
echo 'export PATH="/home/vagrant/sonar-scanner-4.0.0.1744-linux/bin:$PATH"' >> ~/.bashrc 

sudo reboot