#!/usr/bin/env bash

wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x lein
export LEIN_ROOT=1

sudo zypper addrepo http://download.opensuse.org/repositories/devel:/tools:/scm/SLE_11_SP4/devel:tools:scm.repo
sudo zypper install git-core
rpm -Uhv ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/zhy20120210:/SLES-11-SP1-x86-64/SLE_11/x86_64/less-424b-10.3.x86_64.rpm
rpm -Uhv http://anorien.csc.warwick.ac.uk/mirrors/download.opensuse.org/repositories/network/SLE_11_SP4/x86_64/rsync-3.1.1-76.1.x86_64.rpm
rpm -Uhv ftp://rpmfind.net/linux/opensuse/distribution/12.3/repo/oss/suse/x86_64/ctags-2011.8.2-9.1.1.x86_64.rpm

