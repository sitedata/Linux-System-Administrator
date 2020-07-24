#!/bin/bash
# https://github.com/complexorganizations/mysql-manager

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
    # System requirements (uname)
    if ! [ -x "$(command -v uname)" ]; then
        echo "Error: uname  is not installed, please install uname." >&2
        exit
    fi
    # System requirements (sed)
    if ! [ -x "$(command -v sed)" ]; then
        echo "Error: sed  is not installed, please install sed." >&2
        exit
    fi
    # System requirements (openssl)
    if ! [ -x "$(command -v openssl)" ]; then
        echo "Error: openssl  is not installed, please install openssl." >&2
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
    fi
}

# Check Operating System
dist-check

if [ ! -f "/var/www/ghost/config.production.json" ]; then

# Determine password
function mysql-password() {
    echo "Please Set your mysql password"
    echo "   1) Random (Recommended)"
    echo "   2) Custom (Advanced)"
    until [[ "$PASSWORD_CHOICE_SETTINGS" =~ ^[1-2]$ ]]; do
        read -rp "Password choice [1-2]: " -e -i 1 PASSWORD_CHOICE_SETTINGS
    done

    # Apply port response
    case $PASSWORD_CHOICE_SETTINGS in
    1)
        # shellcheck disable=SC2154
        PASSWORD_CHOICE="$(openssl rand -base64 25)"
        ;;
    2)
        PASSWORD_CHOICE="read -rp "Password " -e PASSWORD_CHOICE"
        ;;
    esac
}

# Password
mysql-password

# Install ghost
function install-ghost() {
    # Installation begins here
    if [ "$DISTRO" == "ubuntu" ]; then
        apt-get update
        apt-get install build-essential nginx mysql-server nodejs npm certbot python-certbot-nginx -y
    elif [ "$DISTRO" == "debian" ]; then
        apt-get update
        apt-get install build-essential nginx mysql-server nodejs npm certbot python-certbot-nginx -y
    elif [ "$DISTRO" == "raspbian" ]; then
        apt-get update
        apt-get install build-essential nginx mysql-server nodejs npm certbot python-certbot-nginx -y
    elif [ "$DISTRO" == "centos" ]; then
        dnf upgrade -y
        dnf install epel-release -y
        dnf install nodejs npm nginx mysql-server -y
        dnf install certbot python3-certbot-nginx -y
    elif [ "$DISTRO" == "fedora" ]; then
        dnf upgrade -y
        dnf install epel-release -y
        dnf install nodejs npm nginx mysql-server -y
        dnf install certbot python3-certbot-nginx -y
    elif [ "$DISTRO" == "rhel" ]; then
        dnf upgrade -y
        dnf install epel-release -y
        dnf install nodejs npm nginx mysql-server -y
        dnf install certbot python3-certbot-nginx -y
    fi
        adduser ghost-manager
        usermod -aG sudo ghost-manager
        echo "ghost-manager ALL=(ALL:ALL) ALL" >>/etc/sudoers
        npm install ghost-cli@latest -g
        mkdir -p /var/www/ghost
        chown ghost-manager:ghost-manager /var/www/ghost
        chmod 775 /var/www/ghost
        su - ghost-manager
        cd /var/www/ghost/
        ghost install
        certbot --nginx
        certbot renew --dry-run
}

# Install mysql Server
install-ghost

function configure-nginx() {
    sed -i "s|# server_tokens off;|server_tokens off;|" /etc/nginx/nginx.conf
}

configure-nginx

function mysql-setup() {
mysql_secure_installation
mysql -u root -p
CREATE DATABASE ghost_myssql_database;
CREATE USER `ghost_myssql_user`@`localhost` IDENTIFIED BY 'PASSWORD';
ALTER USER `ghost_myssql_user`@`localhost` IDENTIFIED WITH mysql_native_password BY 'PASSWORD';
GRANT ALL ON ghost_myssql_database.* TO `ghost_myssql_user`@`localhost`;
FLUSH PRIVILEGES;
exit
}

mysql-setup

# Configure Ghost
function configure-ghost() {
    echo "{
   "url":"https://[domain-name].com",
   "server":{
      "host":"127.0.0.1",
      "port":2368
   },
   "database":{
      "client":"mysql",
      "connection":{
         "host":"127.0.0.1",
         "port":3306,
         "user":"[user-name]",
         "password":"[password-here]",
         "database":"[database-name]"
      }
   },
   "mail":{
      "from":"'Support' <support@example.com >",
      "transport":"SMTP",
      "options":{
         "service":"Sendgrid",
         "host":"smtp.sendgrid.net",
         "port":465,
         "secureConnection":true,
         "auth":{
            "user":"apikey",
            "pass":"[sendgrid-api-key]"
         }
      }
   },
   "logging":{
      "level":"info",
      "rotation":{
         "enabled":true
      },
      "transports":[
         "file",
         "stdout"
      ]
   },
   "privacy":{
      "useGravatar":false
   },
   "process":"systemd",
   "paths":{
      "contentPath":"/var/www/ghost/content"
   }
}" >>/var/www/ghost/config.production.json
}

# After Ghost Install
else

function ask-questions() {
