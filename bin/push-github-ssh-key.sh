#!/usr/bin/env bash

success=0
SSH_PUBLIC_KEY_FILE=$HOME/.ssh/id_rsa.pub

if [[ -e $1 ]]
then
    SSH_PUBLIC_KEY_FILE=$1
fi

KEY_NAME=vagrant-key
if [[ -n $2 ]]
then
    KEY_NAME=$2
fi

SSH_PUBLIC_KEY=`cat $SSH_PUBLIC_KEY_FILE`

while (( $success == 0 ))
do
    DATA="{\"title\": \"$KEY_NAME\", \"key\":\"`cat $SSH_PUBLIC_KEY_FILE`\"}"
    echo $DATA
    user=
    while [[ -z $user ]]
    do
        echo -n "Enter github username: "
        read user
    done

    curlout=`curl -Ssu $user --data "$DATA" https://api.github.com/user/keys`
    success=`echo $curlout | grep -v -q '"verified": true\|key is already in use'; echo $?`

    if (( $success == 0 )) 
    then
        echo "Well, that didn't work. Trying again. Here's the curl output:";
        echo $curlout
        echo
    else
        echo "Success? Let's see."
        ssh -T git@github.com
    fi
done
