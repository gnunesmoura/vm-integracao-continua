# !/bin/bash

if ! docker ps --format '{{.Names}}' | grep -w jenkins; then
    sudo docker run -u root -d --name jenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean
fi

if ! docker ps --format '{{.Names}}' | grep -w sonarqube; then
    sudo docker run -d --name sonarqube -p 9000:9000 sonarqube
fi
