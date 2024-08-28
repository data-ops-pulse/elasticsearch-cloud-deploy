#!/bin/bash
set -e

curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor > /usr/share/keyrings/fluentbit-keyring.gpg
CODENAME=jammy
echo "deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/ubuntu/${CODENAME} ${CODENAME} main" | tee -a /etc/apt/sources.list.d/fluentbit.list
sudo apt-get update
sudo apt-get install fluent-bit
