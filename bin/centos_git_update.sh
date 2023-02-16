#!/usr/bin/env bash

sudo yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
sudo yum install gcc perl-ExtUtils-MakeMaker
cd /usr/src
sudo wget https://www.kernel.org/pub/software/scm/git/git-2.10.0.tar.gz 
sudo tar xzf git-2.10.0.tar.gz
cd git-2.10.0
make configure
./configure --prefix=/usr/local
make all
sudo make install
