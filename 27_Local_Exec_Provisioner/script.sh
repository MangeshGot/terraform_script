#!/bin/bash
apt-get update -y
apt-get install nginx -y
echo "<h1> Deployed via Terraform </h1>" > /var/www/html/index.html