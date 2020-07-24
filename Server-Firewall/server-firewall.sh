#!/bin/bash
# https://github.com/complexorganizations/server-firewall

# Require script to be run as root (or with sudo)
function super-user-check() {
  if [ "$EUID" -ne 0 ]; then
    echo "You need to run this script as super user."
    exit
  fi
}

# Check for root
super-user-check

# Pre-Checks
function check-system-requirements() {
  # System requirements (sed)
  if ! [ -x "$(command -v sed)" ]; then
    echo "Error: sed is not installed, please install sed." >&2
    exit
  fi
  # System requirements (chmod)
  if ! [ -x "$(command -v chmod)" ]; then
    echo "Error: chmod is not installed, please install chmod." >&2
    exit
  fi
  # System requirements (source)
  if ! [ -x "$(command -v source)" ]; then
    echo "Error: source is not installed, please install source." >&2
    exit
  fi
}

# Run the function and check for requirements
check-system-requirements

# Detect Operating System
function dist-check() {
  # shellcheck disable=SC1090
  if [ -e /etc/os-release ]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    DISTRO=$ID
    # shellcheck disable=SC2034
    DISTRO_VERSION=$VERSION_ID
  fi
}

# Check Operating System
dist-check

# Install
function install-firewall() {
    if [ "$DISTRO" == "debian" ]; then
      apt-get update
      apt-get install haveged fail2ban ufw lsof -y
    fi
    if [ "$DISTRO" == "ubuntu" ]; then
      apt-get update
      apt-get install haveged fail2ban ufw lsof -y
    fi
    if [ "$DISTRO" == "raspbian" ]; then
      apt-get update
      apt-get install haveged fail2ban ufw lsof -y
    fi
    if [ "$DISTRO" == "arch" ]; then
      pacman -Syu
      pacman -Syu --noconfirm haveged fail2ban lsof ufw
    fi
    if [ "$DISTRO" == "fedora" ]; then
      dnf update -y
      dnf install haveged fail2ban ufw lsof -y
    fi
    if [ "$DISTRO" == "centos" ]; then
      yum update -y
      yum install haveged fail2ban ufw lsof -y
    fi
    if [ "$DISTRO" == "rhel" ]; then
      yum update -y
      yum install haveged fail2ban ufw lsof -y
    fi
    if [ ! -f "/etc/default/ufw" ]; then
      sed -i "s|# IPV6=yes;|IPV6=yes;|" /etc/default/ufw
      ufw default reject incoming
      ufw default allow outgoing
    fi
}

# install the basic firewall
install-firewall

function secure-ssh() {
  if [ ! -f "/root/.ssh/authorized_keys" ]; then
      sed -i "s|#PasswordAuthentication yes|PasswordAuthentication no|" /etc/ssh/sshd_config
      sed -i "s|#PermitEmptyPasswords no|PermitEmptyPasswords no|" /etc/ssh/sshd_config
      sed -i "s|AllowTcpForwarding yes|AllowTcpForwarding no|" /etc/ssh/sshd_config
      sed -i "s|X11Forwarding yes|X11Forwarding no|" /etc/ssh/sshd_config
      sed -i "s|#LogLevel INFO|LogLevel VERBOSE|" /etc/ssh/sshd_config
      sed -i "s|#Port 22|Port 22|" /etc/ssh/sshd_config
      sed -i "s|#PubkeyAuthentication yes|PubkeyAuthentication yes|" /etc/ssh/sshd_config
      sed -i "s|#ChallengeResponseAuthentication no|ChallengeResponseAuthentication yes|" /etc/ssh/sshd_config
    if [ ! -f "/etc/default/ufw" ]; then
      ufw allow 22/tcp
    fi
  fi
}

# Secure SSH
secure-ssh

function secure-web-server() {
  lsof -i :80 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw allow 80/tcp
    fi
  fi
  lsof -i :443 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw allow 443/tcp
    fi
  fi
}

# Secure Web server
secure-web-server

function secure-network-apps() {
  # Wireguard
  lsof -i :51820 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw allow 51820/udp
    fi
  fi
  # shadowsocks
  lsof -i :8388 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw allow 8388/udp
      ufw allow 8388/tcp
    fi
  fi
  # Dns
  lsof -i :53 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw allow 53/tcp
      ufw allow 53/udp
    fi
  fi
  # openvpn
  lsof -i :1194 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw allow 1194/tcp
      ufw allow 1194/udp
    fi
  fi
  # mongodb
  lsof -i :27017 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw reject 27017/tcp
    fi
  fi
  # mysql
  lsof -i :3306 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw reject 3306/tcp
    fi
  fi
  # PostgreSQL
  lsof -i :5432 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw reject 5432/tcp
    fi
  fi
  # Minecraft
  lsof -i :25565 >&2
  if [ $? -eq 1 ]; then
    if [ ! -f "/etc/default/ufw" ]; then
      ufw allow 25565/tcp
      ufw allow 25565/udp
    fi
  fi
}

secure-network-apps

function make-apps-more-secure() {
  # Nginx
  if [ ! -f "/etc/nginx/nginx.conf" ]; then
    sed -i "s|# server_tokens off;|server_tokens off;|" /etc/nginx/nginx.conf
  fi
  # Mongodb
  if [ ! -f "/etc/mongod.conf" ]; then
    sed -i "s|# port: 27017|port: 27017|" /etc/mongod.conf
  fi
  # Fail2ban
  if [ ! -f "/etc/fail2ban/jail.conf" ]; then
    sed -i "s|bantime = 600;|bantime = 1800;|" /etc/nginx/nginx.conf
  fi
}

function enable-service() {
  if pgrep systemd-journal; then
    # ssh
    systemctl enable ssh
    systemctl restart ssh
    # ufw
    ufw enable
    systemctl enable ufw
    systemctl restart ufw
    # fail2ban
    systemctl enable fail2ban
    systemctl restart fail2ban
  else
    # ssh
    service ssh enable
    service ssh restart
    # ufw
    ufw enable
    service ufw enable
    service ufw restart
    # Fail2ban
    service fail2ban enable
    service fail2ban restart
  fi
}

enable-service
