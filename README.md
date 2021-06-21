# ansible-decent-router

This repo contains Ansible playbook to provide decent router experience. Used with [ansible-decent-desktop](https://github.com/komachi/ansible-decent-desktop)


This project is not intended to fulfil desires of every user. I use it to provision my own home router. You probably find some defaults incompatible with your view on router configuration, but you can fork and tune it for yourself, or just look at playbooks for inspirations. PRs with improvements welcomed btw.

This playbook meant to be run against [TurrisOS](https://gitlab.nic.cz/turris/openwrt)/[OpenWRT](https://openwrt.org/).

It focus both on security and speed when it's possible. It uses lightweight software when possible and some specific tuning to meet the goal. Take note that while this README uses word "security" several times, nobody checked this. Think then do.


## Features

- All traffic routed over [Wireguard](https://wireguard.com) connection, with [mullvad](https://mullvad.net) servers chosen randomly every night
- DoT with [stubby](https://github.com/getdnsapi/stubby) and [unbound](https://github.com/NLnetLabs/unbound) as caching server
- Opt-out of [Google's Location Services](https://support.google.com/maps/answer/1725632), [Mozilla Location Service](https://location.services.mozilla.com/optout), Microsoft's [WiFi Sense](https://social.technet.microsoft.com/wiki/contents/articles/32109.disabling-wifi-sense-by-gui-and-gpo-script.aspx)
- Separate guest WiFi network
- [Adblock](https://openwrt.org/packages/pkgdata/adblock)

## Roles

`main.yml` includes it all.

### ssh

Configure ssh

### system

Configure system OpenWRT settings

### network

Configure network

### dns

Configure dns server

### adblock

Configure adblock

### luci

Configure [LuCI](https://openwrt.org/docs/techref/luci)