#!/bin/bash

set -e

wget -O /tmp/chef.deb https://packages.chef.io/stable/ubuntu/12.04/chef_12.11.18-1_i386.deb
dpkg -i /tmp/chef.deb
apt-get install -f
