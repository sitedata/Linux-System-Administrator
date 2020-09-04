#!/bin/bash

## Sanity Checks and automagic
function root-check() {
if [[ "$EUID" -ne 0 ]]; then
  echo "Sorry, you need to run this as root"
  exit
fi
}

## Root Check
root-check

# Detect Operating System
function dist-check() {
  if [ -e /etc/os-release ]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    DISTRO=$ID
    # shellcheck disable=SC2034
    VERSION=$VERSION_ID
  fi
}

# Check Operating System
dist-check

function install-mongodb() {
    apt-get update && apt-get install gnupg -y && wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add - && echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list && apt-get update && apt-get install mongodb-org -y && systemctl enable mongod && systemctl restart mongod
    echo "[Unit]
Description=Disable Transparent Huge Pages (THP)
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=mongod.service
[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null'
[Install]
WantedBy=basic.target" >> /etc/systemd/system/disable-transparent-huge-pages.service
    systemctl daemon-reload && systemctl start disable-transparent-huge-pages && systemctl enable disable-transparent-huge-pages && ufw allow 27017/tcp
    echo "security:
        authorization: 'enabled'" >> /etc/mongod.conf
    echo "vm.swappiness = 1" >> /etc/sysctl.conf && sysctl -p
    reboot
}

install-mongodb
