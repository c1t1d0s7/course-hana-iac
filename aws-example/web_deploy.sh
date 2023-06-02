#!/bin/bash
sudo apt update
sudo apt install -y apache2
sudo systemctl --now enable apache2
echo "<h1> Hello World </h1>" | sudo tee /var/www/html/index.html