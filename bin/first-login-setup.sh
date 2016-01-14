#!/usr/bin/env bash

echo
echo ==================================================
echo Setting up first-login interactive provisioning.
echo ==================================================
echo

echo $@ > ~vagrant/.first-login
chown vagrant:vagrant ~vagrant/.first-login
chmod u+wrx ~vagrant/.first-login


lines=`cat << END


source /vagrant/etc/shellrc
END`

# Only if the lines aren't already there...
# 
grep -qs shellrc ~vagrant/.bashrc

if (( $? != 0 ))
then
    echo $lines >> ~vagrant/.bashrc 
    echo $lines >> ~vagrant/.zshrc
fi
