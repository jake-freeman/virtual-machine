#!/usr/bin/env bash

echo
echo ==================================================
echo Base Provisioning
echo ==================================================
echo

sudo apt-get update

###
### Software installation
###

# Compile! Build! Rah!
#
sudo apt-get install -y      \
    autoconf                 \
    clang-3.5                \
    g++                      \
    g++-arm-linux-gnueabihf  \
    gcc-arm-linux-gnueabihf  \
    libfcgi-dev              \
    libc6-i386               \
    make

# Interpreters and such.
#
sudo apt-get install -y      \
    python                   \
    python-pip               \
    nodejs                   \
    nodejs-legacy            \
    npm                      \
    ruby

# Python tools & libraries
sudo pip install             \
    pyral

# Development libraries and tools.
#
sudo apt-get install -y      \
    curl                     \
    doxygen                  \
    git                      \
    graphviz                 \
    jq                       \
    libcppunit-dev           \
    lldb-3.4                 \
    openjdk-7-jdk            \
    phantomjs                \
    software-properties-common \
    tmux                     \
    valgrind                 \
    vim                      \
    zsh
