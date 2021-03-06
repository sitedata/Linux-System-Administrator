#!/bin/bash
# https://github.com/complexorganizations/shadowsocks-manager

# Require script to be run as root (or with sudo)
function super-user-check() {
    if [ "$EUID" -ne 0 ]; then
        echo "You need to run this script as super user."
        exit
    fi
}

# Check for root
super-user-check

function tun-check() {
    if [ ! -e /dev/net/tun ]; then
        echo "Error: TUN is not enabled, please enable TUN." >&2
        exit
    fi
}

# Tun
tun-check

# Pre-Checks
function check-system-requirements() {
    # System requirements (shuf)
    if ! [ -x "$(command -v shuf)" ]; then
        echo "Error: shuf is not installed, please install shuf." >&2
        exit
    fi
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
    # System requirements (dpkg)
    if ! [ -x "$(command -v dpkg)" ]; then
        echo "Error: dpkg  is not installed, please install dpkg." >&2
        exit
    fi
    # System requirements (curl)
    if ! [ -x "$(command -v curl)" ]; then
        echo "Error: curl  is not installed, please install curl." >&2
        exit
    fi
    # System requirements (jq)
    if ! [ -x "$(command -v jq)" ]; then
        echo "Error: jq  is not installed, please install jq." >&2
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

function usage-guide() {
    # shellcheck disable=SC2027,SC2046
    echo "usage: ./"$(basename "$0")" [options]"
    echo "  --install     Install shadowsocks Server"
    echo "  --start       Start shadowsocks Server"
    echo "  --stop        Stop shadowsocks Server"
    echo "  --restart     Restart shadowsocks Server"
    echo "  --reinstall   Reinstall shadowsocks Server"
    echo "  --uninstall   Uninstall shadowsocks Server"
    echo "  --update      Update shadowsocks Script"
    echo "  --help        Show Usage Guide"
    exit
}

function usage() {
    while [ $# -ne 0 ]; do
        case "${1}" in
        --install)
            shift
            HEADLESS_INSTALL=${HEADLESS_INSTALL:-y}
            ;;
        --start)
            shift
            SHADOWSOCKS_OPTIONS=${SHADOWSOCKS_OPTIONS:-1}
            ;;
        --stop)
            shift
            SHADOWSOCKS_OPTIONS=${SHADOWSOCKS_OPTIONS:-2}
            ;;
        --restart)
            shift
            SHADOWSOCKS_OPTIONS=${SHADOWSOCKS_OPTIONS:-3}
            ;;
        --reinstall)
            shift
            SHADOWSOCKS_OPTIONS=${SHADOWSOCKS_OPTIONS:-5}
            ;;
        --uninstall)
            shift
            SHADOWSOCKS_OPTIONS=${SHADOWSOCKS_OPTIONS:-4}
            ;;
        --update)
            shift
            SHADOWSOCKS_OPTIONS=${SHADOWSOCKS_OPTIONS:-6}
            ;;
        --help)
            shift
            usage-guide
            ;;
        *)
            echo "Invalid argument: $1"
            usage-guide
            exit
            ;;
        esac
        shift
    done
}

usage "$@"

# Skips all questions and just get a client conf after install.
function headless-install() {
    if [ "$HEADLESS_INSTALL" == "y" ]; then
        PORT_CHOICE_SETTINGS=${IPV4_SUBNET_SETTINGS:-1}
        PASSWORD_CHOICE_SETTINGS=${IPV6_SUBNET_SETTINGS:-1}
        ENCRYPTION_CHOICE_SETTINGS=${ENCRYPTION_CHOICE_SETTINGS:-1}
        TIMEOUT_CHOICE_SETTINGS=${TIMEOUT_CHOICE_SETTINGS:-1}
        SERVER_HOST_V4_SETTINGS=${SERVER_HOST_V4_SETTINGS:-1}
        SERVER_HOST_V6_SETTINGS=${SERVER_HOST_V6_SETTINGS:-1}
        SERVER_HOST_SETTINGS=${SERVER_HOST_SETTINGS:-1}
        DISABLE_HOST_SETTINGS=${DISABLE_HOST_SETTINGS:-1}
        MODE_CHOICE_SETTINGS=${MODE_CHOICE_SETTINGS:-1}
        INSTALL_BBR=${INSTALL_BBR:-y}
    fi
}

# No GUI
headless-install

if [ ! -f "/var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json" ]; then

    # Question 1: Determine host port
    function set-port() {
        echo "What port do you want Shadowsocks to listen to?"
        echo "   1) 80 (Recommended)"
        echo "   2) 443"
        echo "   3) Custom (Advanced)"
        until [[ "$PORT_CHOICE_SETTINGS" =~ ^[1-3]$ ]]; do
            read -rp "Port choice [1-3]: " -e -i 1 PORT_CHOICE_SETTINGS
        done

        # Apply port response
        case $PORT_CHOICE_SETTINGS in
        1)
            SERVER_PORT="80"
            ;;
        2)
            SERVER_PORT="443"
            ;;
        3)
            until [[ "$SERVER_PORT" =~ ^[0-9]+$ ]] && [ "$SERVER_PORT" -ge 1 ] && [ "$SERVER_PORT" -le 65535 ]; do
                read -rp "Custom port [1-65535]: " -e -i 80 SERVER_PORT
            done
            ;;
        esac
    }

    # Set the port number
    set-port

    # Determine password
    function shadowsocks-password() {
        echo "Choose your password"
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
    shadowsocks-password

    # Determine Encryption
    function shadowsocks-encryption() {
        echo "Choose your Encryption"
        echo "   1) aes-256-gcm (Recommended)"
        echo "   2) aes-256-ctr"
        echo "   3) chacha20-ietf-poly1305"
        until [[ "$ENCRYPTION_CHOICE_SETTINGS" =~ ^[1-3]$ ]]; do
            read -rp "Encryption choice [1-3]: " -e -i 1 ENCRYPTION_CHOICE_SETTINGS
        done

        # Apply port response
        case $ENCRYPTION_CHOICE_SETTINGS in
        1)
            ENCRYPTION_CHOICE="aes-256-gcm"
            ;;
        2)
            ENCRYPTION_CHOICE="aes-256-ctr"
            ;;
        3)
            ENCRYPTION_CHOICE="chacha20-ietf-poly1305"
            ;;
        esac
    }

    # encryption
    shadowsocks-encryption

    # Determine Encryption
    function shadowsocks-timeout() {
        echo "Choose your timeout"
        echo "   1) 60 (Recommended)"
        echo "   2) 180"
        echo "   3) Custom (Advanced)"
        until [[ "$TIMEOUT_CHOICE_SETTINGS" =~ ^[1-3]$ ]]; do
            read -rp "Timeout choice [1-3]: " -e -i 1 TIMEOUT_CHOICE_SETTINGS
        done

        # Apply port response
        case $TIMEOUT_CHOICE_SETTINGS in
        1)
            TIMEOUT_CHOICE="60"
            ;;
        2)
            TIMEOUT_CHOICE="180"
            ;;
        3)
            until [[ "$TIMEOUT_CHOICE" =~ ^[0-9]+$ ]] && [ "$TIMEOUT_CHOICE" -ge 1 ] && [ "$TIMEOUT_CHOICE" -le 900 ]; do
                read -rp "Custom [1-900]: " -e -i 60 TIMEOUT_CHOICE
            done
            ;;
        esac
    }

    # timeout
    shadowsocks-timeout

    # Determine host port
    function test-connectivity-v4() {
        echo "How would you like to detect IPV4?"
        echo "  1) Curl (Recommended)"
        echo "  2) IP (Advanced)"
        echo "  3) Custom (Advanced)"
        until [[ "$SERVER_HOST_V4_SETTINGS" =~ ^[1-3]$ ]]; do
            read -rp "ipv4 choice [1-3]: " -e -i 1 SERVER_HOST_V4_SETTINGS
        done
        # Apply port response
        case $SERVER_HOST_V4_SETTINGS in
        1)
            SERVER_HOST_V4="$(curl -4 -s 'https://api.ipengine.dev' | jq -r '.network.ip)"
            ;;
        2)
            SERVER_HOST_V4=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
            ;;
        3)
            read -rp "Custom IPV4: " -e -i "$(curl -4 -s 'https://api.ipengine.dev' | jq -r '.network.ip')" SERVER_HOST_V4
            ;;
        esac
    }

    # Set Port
    test-connectivity-v4

    # Determine ipv6
    function test-connectivity-v6() {
        echo "How would you like to detect IPV6?"
        echo "  1) Curl (Recommended)"
        echo "  2) IP (Advanced)"
        echo "  3) Custom (Advanced)"
        until [[ "$SERVER_HOST_V6_SETTINGS" =~ ^[1-3]$ ]]; do
            read -rp "ipv6 choice [1-3]: " -e -i 1 SERVER_HOST_V6_SETTINGS
        done
        # Apply port response
        case $SERVER_HOST_V6_SETTINGS in
        1)
            SERVER_HOST_V6="$(curl -6 -s 'https://api.ipengine.dev' | jq -r '.network.ip')"
            ;;
        2)
            SERVER_HOST_V6=$(ip r get to 2001:4860:4860::8888 | perl -ne '/src ([\w:]+)/ && print "$1\n"')
            ;;
        3)
            read -rp "Custom IPV6: " -e -i "$(curl -6 -s 'https://api.ipengine.dev' | jq -r '.network.ip')" SERVER_HOST_V6
            ;;
        esac
    }

    # Set Port
    test-connectivity-v6

    # What ip version would you like to be available on this VPN?
    function ipvx-select() {
        echo "What IPv do you want to use to connect to ShadowSocks server?"
        echo "  1) IPv4 (Recommended)"
        echo "  2) IPv6"
        echo "  3) Custom (Advanced)"
        until [[ "$SERVER_HOST_SETTINGS" =~ ^[1-3]$ ]]; do
            read -rp "IP Choice [1-3]: " -e -i 1 SERVER_HOST_SETTINGS
        done
        case $SERVER_HOST_SETTINGS in
        1)
            SERVER_HOST="$SERVER_HOST_V4"
            ;;
        2)
            SERVER_HOST="[$SERVER_HOST_V6]"
            ;;
        3)
            read -rp "Custom Domain: " -e -i "$(curl -4 -s 'https://api.ipengine.dev' | jq -r '.network.hostname')" SERVER_HOST
            ;;
        esac
    }

    # IPv4 or IPv6 Selector
    ipvx-select

    # Do you want to disable IPv4 or IPv6 or leave them both enabled?
    function disable-ipvx() {
        echo "Do you want to disable IPv4 or IPv6 on the server?"
        echo "  1) No (Recommended)"
        echo "  2) Disable IPV4"
        echo "  3) Disable IPV6"
        until [[ "$DISABLE_HOST_SETTINGS" =~ ^[1-3]$ ]]; do
            read -rp "Disable Host Choice [1-3]: " -e -i 1 DISABLE_HOST_SETTINGS
        done
        case $DISABLE_HOST_SETTINGS in
        1)
            DISABLE_HOST="$(
                echo "net.ipv4.ip_forward=1" >>/etc/sysctl.d/shadowsocks.conf
                echo "net.ipv6.conf.all.forwarding=1" >>/etc/sysctl.d/shadowsocks.conf
                sysctl -p
            )"
            ;;
        2)
            DISABLE_HOST="$(
                echo "net.ipv6.conf.all.forwarding=1" >>/etc/sysctl.d/shadowsocks.conf
                sysctl -p
            )"
            ;;
        3)
            # shellcheck disable=SC2034
            DISABLE_HOST="$(
                echo "net.ipv4.ip_forward=1" >>/etc/sysctl.d/shadowsocks.conf
                sysctl -p
            )"
            ;;
        esac
    }

    # Disable Ipv4 or Ipv6
    disable-ipvx

    # Determine TCP or UDP
    function shadowsocks-mode() {
        echo "Choose your method (UDP|TCP)"
        echo "   1) (TCP|UDP) (Recommended)"
        echo "   2) TCP"
        echo "   3) UDP"
        until [[ "$MODE_CHOICE_SETTINGS" =~ ^[1-3]$ ]]; do
            read -rp "Mode choice [1-3]: " -e -i 1 MODE_CHOICE_SETTINGS
        done

        # Apply port response
        case $MODE_CHOICE_SETTINGS in
        1)
            MODE_CHOICE="tcp_and_udp"
            ;;
        2)
            MODE_CHOICE="tcp"
            ;;
        3)
            MODE_CHOICE="udp"
            ;;
        esac
    }

    # Mode
    shadowsocks-mode

    function sysctl-install() {
        # Ammend configuration specifics for sysctl.conf
        echo \
        'fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = hybla' \
        >>/etc/sysctl.d/shadowsocks.conf
        sysctl -p
    }

    function install-bbr() {
        if [ "$INSTALL_BBR" == "" ]; then
            # shellcheck disable=SC2034
            read -rp "Do You Want To Install TCP bbr (y/n): " -e -i y INSTALL_BBR
        fi
        if [ "$INSTALL_BBR" = "y" ]; then
            # Run the systemctl install command
            sysctl-install
            # Check if tcp brr can be installed and if yes than install
            KERNEL_VERSION_LIMIT=4.1
            KERNEL_CURRENT_VERSION=$(uname -r | cut -c1-3)
            if (($(echo "$KERNEL_CURRENT_VERSION >= $KERNEL_VERSION_LIMIT" | bc -l))); then
                modprobe tcp_bbr
                echo "tcp_bbr" >>/etc/modules-load.d/modules.conf
                echo "net.core.default_qdisc=fq" >>/etc/sysctl.d/shadowsocks.conf
                echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.d/shadowsocks.conf
                sysctl -p
            else
                echo "Error: Please update your kernel to 4.1 or higher" >&2
            fi
        fi
    }

    # Install TCP BBR
    install-bbr

    # Install shadowsocks Server
    function install-shadowsocks-server() {
        # Installation begins here
        if [ "$DISTRO" == "ubuntu" ]; then
            apt-get update
            apt-get install snapd haveged qrencode -y
            snap install core shadowsocks-libev
        elif [ "$DISTRO" == "debian" ]; then
            apt-get update
            apt-get install snapd haveged qrencode -y
            snap install core shadowsocks-libev
        elif [ "$DISTRO" == "raspbian" ]; then
            apt-get update
            apt-get install snapd haveged qrencode -y
            snap install core shadowsocks-libev
        elif [ "$DISTRO" == "centos" ]; then
            dnf upgrade -y
            dnf install epel-release -y
            yum install snapd haveged -y
            snap install core shadowsocks-libev
        elif [ "$DISTRO" == "fedora" ]; then
            dnf upgrade -y
            dnf install epel-release -y
            yum install snapd haveged -y
            snap install core shadowsocks-libev
        elif [ "$DISTRO" == "rhel" ]; then
            dnf upgrade -y
            dnf install epel-release -y
            yum install snapd haveged -y
            snap install core shadowsocks-libev
        fi
    }

    # Install shadowsocks Server
    install-shadowsocks-server

    function v2ray-install() {
        CHECK_ARCHITECTURE=$(dpkg --print-architecture)
        # shellcheck disable=SC2086
        FILE_NAME=$(v2ray-plugin-linux-$CHECK_ARCHITECTURE-v1.3.1.tar.gz)
        # shellcheck disable=SC2086
        curl https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.1/$FILE_NAME --create-dirs -o /etc/shadowsocks-libev/$FILE_NAME
        # shellcheck disable=SC2086
        tar xvzf /etc/shadowsocks-libev/$FILE_NAME
        # shellcheck disable=SC2086
        rm -f /etc/shadowsocks-libev/$FILE_NAME
    }

    function shadowsocks-configuration() {
        # shellcheck disable=SC2016
        mkdir /var/snap/shadowsocks-libev/common/etc
        mkdir /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev
        # shellcheck disable=SC1078,SC1079
        echo "{
  ""\"server""\":""\"$SERVER_HOST""\",
  ""\"mode""\":""\"$MODE_CHOICE""\",
  ""\"server_port""\":""\"$SERVER_PORT""\",
  ""\"password""\":""\"$PASSWORD_CHOICE""\",
  ""\"timeout""\":""\"$TIMEOUT_CHOICE""\",
  ""\"method""\":""\"$ENCRYPTION_CHOICE""\"
  }" >>/var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
        if pgrep systemd-journal; then
            snap run shadowsocks-libev.ss-server &
        else
            snap run shadowsocks-libev.ss-server &
        fi
    }

    # Shadowsocks Config
    shadowsocks-configuration

    function show-config() {
        clear
        qrencode -t ansiutf8 -l L </var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
        echo "Config File ---> /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json"
        echo "Shadowsocks Server IP: $SERVER_HOST"
        echo "Shadowsocks Server Port: $SERVER_PORT"
        echo "Shadowsocks Server Password: $PASSWORD_CHOICE"
        echo "Shadowsocks Server Encryption: $ENCRYPTION_CHOICE"
        echo "Shadowsocks Server Mode: $MODE_CHOICE"
    }

    # Show the config
    show-config

# After Shadowsocks Install
else

    # Already installed what next?
    function shadowsocks-next-questions() {
        echo "What do you want to do?"
        echo "   1) Start ShadowSocks"
        echo "   2) Stop ShadowSocks"
        echo "   3) Restart ShadowSocks"
        echo "   4) Uninstall ShadowSocks"
        echo "   5) Reinstall ShadowSocks"
        echo "   6) Update this script"
        until [[ "$SHADOWSOCKS_OPTIONS" =~ ^[1-6]$ ]]; do
            read -rp "Select an Option [1-6]: " -e -i 1 SHADOWSOCKS_OPTIONS
        done
        case $SHADOWSOCKS_OPTIONS in
        1)
            snap run shadowsocks-libev.ss-server &
            ;;
        2)
            snap stop shadowsocks-libev.ss-server &
            ;;
        3)
            snap restart shadowsocks-libev.ss-server &
            ;;
        4)
            snap stop shadowsocks-libev.ss-server &
            if [ "$DISTRO" == "ubuntu" ]; then
                snap remove --purge shadowsocks-libev -y
                apt-get remove --purge snapd haveged -y
            elif [ "$DISTRO" == "debian" ]; then
                snap remove --purge shadowsocks-libev -y
                apt-get remove --purge snapd haveged -y
            elif [ "$DISTRO" == "raspbian" ]; then
                snap remove --purge shadowsocks-libev -y
                apt-get remove --purge snapd haveged -y
            elif [ "$DISTRO" == "centos" ]; then
                snap remove --purge shadowsocks-libev -y
                yum remove snapd -y
            elif [ "$DISTRO" == "fedora" ]; then
                snap remove --purge shadowsocks-libev -y
                yum remove snapd -y
            elif [ "$DISTRO" == "rhel" ]; then
                snap remove --purge shadowsocks-libev -y
                yum remove snapd -y
            fi
            rm -f /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
            sed -i 's/\* soft nofile 51200//d' /etc/security/limits.conf
            sed -i 's/\* hard nofile 51200//d' /etc/security/limits.conf
            sed -i 's/\tcp_bbr//d' /etc/modules-load.d/modules.conf
            rm -f /etc/sysctl.d/shadowsocks.conf
            rm -rf /var/snap/shadowsocks-libev
            ;;
        5)
            if pgrep systemd-journal; then
                dpkg-reconfigure shadowsocks-libev
                modprobe shadowsocks-libev
                systemctl restart shadowsocks-libev
            else
                dpkg-reconfigure shadowsocks-libev
                modprobe shadowsocks-libev
                service shadowsocks-libev restart
            fi
            ;;
        6) # Update the script
            curl -o /var/snap/shadowsocks-libev/shadowsocks-server.sh https://raw.githubusercontent.com/complexorganizations/shadowsocks-manager/master/shadowsocks-server.sh
            chmod +x /var/snap/shadowsocks-libev/shadowsocks-server.sh || exit
            ;;
        esac
    }

    # Running Questions Command
    shadowsocks-next-questions

fi
