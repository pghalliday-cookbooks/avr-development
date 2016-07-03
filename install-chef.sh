#!/bin/bash

set -e

wget -O /tmp/chef.deb https://packages.chef.io/stable/ubuntu/10.04/chef_12.10.24-1_amd64.deb
dpkg -i /tmp/chef.deb
apt-get install -f
