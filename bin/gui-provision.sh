#!/usr/bin/env bash

echo
echo ==================================================
echo GUI Provisioning
echo ==================================================
echo

sudo apt-get install -y      \
    ubuntu-desktop           \
    virtualbox-guest-dkms    \
    virtualbox-guest-utils   \
    virtualbox-guest-x11     \
    valkyrie                 \
    meld                     \
    chromium-browser


# Sublime!
#
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get -y install sublime-text-installer


# Disable the lock screen and idle timeout. 
# 
eval `dbus-launch --auto-syntax` && \
    dconf write /org/gnome/desktop/session/idle-delay 1 && \
    dconf write /org/gnome/desktop/screensaver/lock-enabled false
