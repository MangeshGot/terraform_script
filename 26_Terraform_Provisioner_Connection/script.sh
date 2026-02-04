#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx -y
sudo -i
echo "<h1> Deployed via Terraform </h1>" > /var/www/html/index.html