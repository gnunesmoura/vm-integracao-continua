#!/bin/bash
sudo apt-get update
sudo apt-get install -y --install-recommends --force linux-generic-lts-xenial 
sudo apt-get upgrade -y
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536
sudo apt-get install -y git unzip

wget  -P ./ "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.0.0.1744-linux.zip" >> /dev/null
unzip sonar-scanner-cli-4.0.0.1744-linux.zip  >> /dev/null
echo 'export PATH="/home/vagrant/sonar-scanner-4.0.0.1744-linux/bin:$PATH"' >> ~/.bashrc 