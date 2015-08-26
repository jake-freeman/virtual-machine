#!/usr/bin/env bash

echo
echo ==================================================
echo Target Provisioning
echo ==================================================
echo

###
### Targety stuff
###

# Make sure we have "add-apt-repository", first.
sudo apt-get install software-properties-common
# Make sure to do an update after adding another apt repository.
# Otherwise it'll use the old nginx version, instead of the new one.
sudo add-apt-repository -y ppa:nginx/stable && sudo apt-get update
sudo apt-get install -y nginx

sudo chmod 666 /dev/ttyS*

###
### Time!
###
sudo timedatectl set-timezone America/Chicago
