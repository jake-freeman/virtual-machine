#!/usr/bin/env bash

if [[ -e $HOME/.first-login ]]; then
    args=(`cat $HOME/.first-login`)
    HOST_USER=${args[0]}

    USER_FIRST_LOGIN=/vagrant/users/$HOST_USER/first-login.sh

    echo
    echo ==================================================
    echo "First login. Attempting to run user's first login script at $USER_FIRST_LOGIN"
    echo Setting up first-login interactive provisioning.
    echo ==================================================
    echo

    if [[ -x $USER_FIRST_LOGIN ]]
    then
        $USER_FIRST_LOGIN $*
    fi

    rm $HOME/.first-login
fi
