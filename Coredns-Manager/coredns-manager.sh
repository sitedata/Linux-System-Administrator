#!/bin/bash

# Require script to be run as root (or with sudo)
function super-user-check() {
    if [ "$EUID" -ne 0 ]; then
        echo "You need to run this script as super user."
        exit
    fi
}

# Check for root
super-user-check

# Detect Operating System
function dist-check() {
    # shellcheck disable=SC1090
    if [ -e /etc/os-release ]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        DISTRO=$ID
    fi
}

# Check Operating System
dist-check

function install-coredns() {
if ([ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "arch" ] || [ "$DISTRO" == "raspbian" ] || [ "$DISTRO" == "centos" ] || [ "$DISTRO" == "fedora" ] || [ "$DISTRO" == "rhel" ]); then
    mkdir -p /etc/coredns
    cd /etc/coredns
    url -LJO https://github.com/coredns/coredns/releases/download/v1.6.9/coredns_1.6.9_linux_amd64.tgz
    tar xvzf /etc/coredns/coredns_1.6.9_linux_amd64.tgz
    rm -f /etc/coredns/coredns_1.6.9_linux_amd64.tgz
fi
}

install-coredns

function coredns-config() {
echo ".:53 {
	forward . tls://1.1.1.1 tls://1.0.0.1 tls://2606:4700:4700::1111 tls://2606:4700:4700::1001 {
		tls_servername tls.cloudflare-dns.com
		health_check 10s
	}
	cache
	errors
	reload
	loop
	log
	health
	dnssec
	metadata
}" >> /etc/coredns/Corefile
}

coredns-config

function coredns-service() {
echo "[Unit]
Description=CoreDNS DNS Server
Documentation=https://coredns.io/manual/
After=network.target

[Service]
ExecStart=/etc/coredns/coredns -conf /etc/coredns/Corefile
Restart=on-failure

[Install]
WantedBy=multi-user.target" >> /lib/systemd/system/coredns.service
}

coredns-service

if pgrep systemd-journal; then
     systemctl enable coredns
     systemctl restart coredns
else
     service coredns enable
     service coredns restart
fi
