#!/bin/bash

set -e

TARGET=$1
SSH_DIR=/root/.ssh

mkdir -p $SSH_DIR
chmod 0700 $SSH_DIR
scp $TARGET:.ssh/id_rsa $SSH_DIR/id_rsa
scp $TARGET:.ssh/id_rsa.pub $SSH_DIR/authorized_keys
