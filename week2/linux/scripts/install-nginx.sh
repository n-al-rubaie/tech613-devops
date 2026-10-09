#!/bin/bash

# purpose of this script: run on fresh ubuntu 24.04, install nginx

# update
sudo apt-get update
# upgrade
sudo apt-get upgrade -y

# install nginx
sudo apt-get install nginx -y

# restart nginx - important if you change the nginx configuration
sudo systemctl restart nginx

# enable nginx
sudo systemctl enable nginx
