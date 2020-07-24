<h1 align="center">Server Firewall</h1>
<p align="center">
  <a href="https://github.com/complexorganizations/server-firewall/releases">
    <img alt="Release" src="https://img.shields.io/github/v/release/complexorganizations/server-firewall" target="_blank" />
  </a>
  <a href="https://github.com/complexorganizations/server-firewall/actions">
    <img alt="ShellCheck" src="https://github.com/complexorganizations/server-firewall/workflows/ShellCheck/badge.svg" target="_blank" />
  </a>
  <a href="https://github.com/complexorganizations/server-firewall/issues">
    <img alt="Issues" src="https://img.shields.io/github/issues/complexorganizations/server-firewall" target="_blank" />
  </a>
  <a href="https://github.com/sponsors/Prajwal-Koirala">
    <img alt="Sponsors" src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub" target="_blank" />
  </a>
  <a href="https://raw.githubusercontent.com/complexorganizations/server-firewall/master/.github/LICENSE">
    <img alt="PullRequest" src="https://img.shields.io/github/issues-pr/complexorganizations/server-firewall" target="_blank" />
  </a>
  <a href="https://raw.githubusercontent.com/complexorganizations/server-firewall/master/.github/license">
    <img alt="License" src="https://img.shields.io/github/license/complexorganizations/server-firewall" target="_blank" />
  </a>
</p>

---
### 📲 Installation
Lets first use `curl` and save the file in `/etc/firewall`
```
curl https://raw.githubusercontent.com/complexorganizations/server-firewall/master/server-firewall.sh --create-dirs -o /etc/firewall/server-firewall.sh
```
Then let's make the script user executable (Optional)
```
chmod +x /etc/firewall/server-firewall.sh
```
It's finally time to execute the script
```
bash /etc/firewall/server-firewall.sh
```

### ⛳ Goals
 - robust and modern security by default
 - minimal config and critical management
 - fast, both low-latency and high-bandwidth
 - simple internals and small protocol surface area
 - simple CLI and seamless integration with system networking
 
 ---
### 🥰 Features
- Installs and configures a ready-to-use WireGuard Interface
- (IPv4|IPv6) Supported, (IPv4|IPv6) Leak Protection
- Iptables rules and forwarding managed in a seamless way
- If needed, the script can cleanly remove WireGuard, including configuration and iptables rules
- Variety of DNS resolvers to be pushed to the clients
- The choice to use a self-hosted resolver with Unbound.
- Preshared-key for an extra layer of security.
- Block DNS leaks
- Dynamic DNS supported
- Many other little things!

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
### 🤝 Developing
Using a browser based development environment:

[![Open in Gitpod](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/complexorganizations/server-firewall)

### 🐛 Debugging
```
git clone https://github.com/complexorganizations/server-firewall /etc/firewall/
```

---
### 📝 License
Copyright © 2020 [Prajwal](https://github.com/prajwal-koirala)

This project is [MIT](https://raw.githubusercontent.com/complexorganizations/server-firewall/master/.github/LICENSE) licensed.
