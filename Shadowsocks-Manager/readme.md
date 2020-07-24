<h1 align="center">Shadowsocks Manager 👋</h1>
<p align="center">
  <a href="https://github.com/complexorganizations/shadowsocks-manager/releases">
    <img alt="Release" src="https://img.shields.io/github/v/release/complexorganizations/shadowsocks-manager" target="_blank" />
  </a>
  <a href="https://github.com/complexorganizations/shadowsocks-manager/actions">
    <img alt="ShellCheck" src="https://github.com/complexorganizations/shadowsocks-manager/workflows/ShellCheck/badge.svg" target="_blank" />
  </a>
  <a href="https://github.com/complexorganizations/shadowsocks-manager/issues">
    <img alt="Issues" src="https://img.shields.io/github/issues/complexorganizations/shadowsocks-manager" target="_blank" />
  </a>
  <a href="https://github.com/sponsors/Prajwal-Koirala">
    <img alt="Sponsors" src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub" target="_blank" />
  </a>
  <a href="https://raw.githubusercontent.com/complexorganizations/shadowsocks-manager/master/.github/LICENSE">
    <img alt="PullRequest" src="https://img.shields.io/github/issues-pr/complexorganizations/shadowsocks-manager" target="_blank" />
  </a>
  <a href="https://raw.githubusercontent.com/complexorganizations/shadowsocks-manager/master/.github/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/complexorganizations/shadowsocks-manager" target="_blank" />
  </a>
</p>

---
### 🤷 What is proxy ?
A proxy server in computer networking is a server application or appliance which acts as an intermediary for requests from clients seeking resources from servers providing those resources.

### 📶 What is shadowsocks ?
Shadowsocks is a free and open-source encryption protocol project which is commonly used to bypass Internet censorship in mainland China. It was developed by a Chinese programmer called "clowwindy" in 2012, and many protocol implementations have since been made available.

### ⛳ Goals
 - robust and modern security by default
 - minimal config and critical management
 - fast, both low-latency and high-bandwidth
 - simple internals and small protocol surface area
 - simple CLI and seamless integration with system networking
 
---
### 📲 Installation
Lets first use `curl` and save the file in `/var/snap/shadowsocks-libev`
```
curl https://raw.githubusercontent.com/complexorganizations/shadowsocks-manager/master/shadowsocks-server.sh --create-dirs -o /var/snap/shadowsocks-libev/shadowsocks-server.sh
```
Then let's make the script user executable (Optional)
```
chmod +x /var/snap/shadowsocks-libev/shadowsocks-server.sh
```
It's finally time to execute the script
```
bash /var/snap/shadowsocks-libev/shadowsocks-server.sh
```

---
### 💣 After Installation
- Show shadowsocks server
- Start shadowsocks server
- Stop shadowsocks server
- Restart shadowsocks server
- Reinstall shadowsocks server
- Uninstall shadowsocks server
- Update this script

---
### 🔑 Usage
```
usage: ./shadowsocks-server.sh [options]
  --install     Install shadowsocks Server
  --start       Start shadowsocks Server
  --stop        Stop shadowsocks Server
  --restart     Restart shadowsocks Server
  --reinstall   Reinstall shadowsocks Server
  --uninstall   Uninstall shadowsocks Server
  --update      Update shadowsocks Script
  --help        Show Usage Guide
```

---
### 🥰 Features
- Installs and configures a ready-to-use shadowsocks Server
- (IPv4|IPv6) Supported, (IPv4|IPv6) Leak Protection
- Iptables rules and forwarding managed in a seamless way
- If needed, the script can cleanly remove shadowsocks, including configuration and iptables rules
- Block DNS leaks
- Dynamic DNS supported
- Many other little things!

---
### 💡 Options
* `SERVER_PORT` - public port for shadowsocks server, default is `80`
* `DISABLE_HOST` - Disable or enable ipv4 and ipv6, default disabled
* `ENCRYPTION_CHOICE` - 
* `PASSWORD_CHOICE` - 

---
### 👉👈 Compatibility with Linux Distro
| OS              | Supported          | i386               | amd64              | armhf              | arm64              |
| --------------  | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ |
| Ubuntu 14 ≤     |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| Ubuntu 16       |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Ubuntu 18       |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Ubuntu 19 ≥     |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Debian 7 ≤      |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| Debian 8        |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Debian 9        |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Debian 10 ≥     |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| CentOS 6 ≤      |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| CentOS 7        |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| CentOS 8 ≥      |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Fedora 29 ≤     |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| Fedora 30       |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Fedora 31       |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Fedora 32 ≥     |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| RedHat 6 ≤      |:x:                 |:x:                 |:x:                 |:x:                 |:x:                 |
| RedHat 7        |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| RedHat 8 ≥      |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Arch            |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
| Raspbian        |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |:white_check_mark:  |
### ☁️ Compatibility with Cloud Providers
| Cloud           | Supported          |
| --------------  | ------------------ |
| AWS             |:white_check_mark:  |
| Google Cloud    |:white_check_mark:  |
| Linode          |:white_check_mark:  |
| Digital Ocean   |:white_check_mark:  |
| Vultr           |:white_check_mark:  |
| Microsoft Azure |:white_check_mark:  |
| OpenStack       |:white_check_mark:  |
| Rackspace       |:white_check_mark:  |
| Scaleway        |:white_check_mark:  |
| EuroVPS         |:white_check_mark:  |
| Hetzner Cloud   |:white_check_mark:  |
| Strato          |:white_check_mark:  |
### 💻 Compatibility with Linux Kernel
| Kernel          | Supported          |
| --------------  | ------------------ |
| Kernel 5.4 ≥    |:white_check_mark:  |
| Kernel 4.19     |:white_check_mark:  |
| Kernel 4.14     |:white_check_mark:  |
| Kernel 4.9      |:white_check_mark:  |
| Kernel 4.4      |:white_check_mark:  |
| Kernel 3.16     |:x:                 |
| Kernel 3.1 ≤    |:x:                 |

---
### 🙋 Q&A
Which hosting provider do you recommend?
- [Google Cloud](https://gcpsignup.page.link/H9XL): Worldwide locations, starting at $10/month
- [Vultr](https://www.vultr.com/?ref=8211592): Worldwide locations, IPv6 support, starting at $3.50/month
- [Digital Ocean](https://m.do.co/c/fb46acb2b3b1): Worldwide locations, IPv6 support, starting at $5/month
- [Linode](https://www.linode.com/?r=63227744138ea4f9d2dff402cfe5b8ad19e45dae): Worldwide locations, IPv6 support, starting at $5/month

Which shadowsocks client do you recommend?
- Windows: [shadowsocks](https://getoutline.org/en/home).
- Android: [shadowsocks](https://play.google.com/store/apps/details?id=com.github.shadowsocks).
- macOS: [shadowsocks](https://apps.apple.com/app/outline-app/id1356178125).
- iOS: [shadowsocks](https://apps.apple.com/app/outline-app/id1356177741).

Is there shadowsocks documentation?
- Yes, please head to the [shadowsocks Manual](https://www.shadowsocks.com), which references all the options.

How do I install a shadowsocks without the questions? (Headless Install) ***Server Only***
- ```HEADLESS_INSTALL=y /etc/shadowsocks/shadowsocks-server.sh```

Official Links
- Homepage: https://www.shadowsocks.org
- Whitepaper: https://shadowsocks.org/assets/whitepaper.pdf

---
### 📐 Architecture

---
### 🤝 Developing
Using a browser based development environment:

[![Open in Gitpod](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/complexorganizations/shadowsocks-manager)

### 🐛 Debugging
```
git clone https://github.com/complexorganizations/shadowsocks-manager /etc/shadowsocks-libev/
bash -x /etc/shadowsocks-libev/shadowsocks-(server|client).sh >> /etc/shadowsocks/shadowsocks-(server|client).log
```

---
### 👤 Author

* Name: Prajwal Koirala
* Website: https://www.prajwalkoirala.com
* Github: [@prajwal-koirala](https://github.com/prajwal-koirala)
* LinkedIn: [@prajwal-koirala](https://www.linkedin.com/in/prajwal-koirala)
* Twitter: [@Prajwal_K23](https://twitter.com/Prajwal_K23)
* Reddit: [@prajwalkoirala23](https://www.reddit.com/user/prajwalkoirala23)
* Twitch: [@prajwalkoirala23](https://www.twitch.tv/prajwalkoirala23)

---
### ⛑️ Support

Give a ⭐️ and 🍴 if this project helped you!

<p align="center">
<a href="https://github.com/sponsors/Prajwal-Koirala">
  <img alt="Sponsors" src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub" target="_blank" />
</a>
</p>

- BCH : `qzq9ae4jlewtz7v7mn4tv7kav3dc9rvjwsg5f36099`
- BSV : ``
- BTC : `3QgnfTBaW4gn4y8QPEdXNJY6Y74nBwRXfR`
- DAI : `0x8DAd9f838d5F2Ab6B14795d47dD1Fa4ED7D1AcaB`
- ETC : `0xd42D20D7E1fC0adb98B67d36691754E3F944478A`
- ETH : `0xe000C5094398dd83A3ef8228613CF4aD134eB0EA`
- LTC : `MVwkmnnaLDq7UccDeudcpQYwFnnDwDxxmq`
- XRP : `rw2ciyaNshpHe7bCHo4bRWq6pqqynnWKQg (1790476900)`

---
### ❤️ Credits

---
### 📝 License
Copyright © 2020 [Prajwal](https://github.com/prajwal-koirala).<br />
This project is [MIT](https://raw.githubusercontent.com/complexorganizations/shadowsocks-manager/master/.github/LICENSE) licensed.
