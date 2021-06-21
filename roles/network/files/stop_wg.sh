#!/bin/sh
WG_IF="wg0"

uci -q delete network.${WG_IF}
uci -q delete network.wireguard_${WG_IF}
uci commit network
/etc/init.d/network restart

uci -q delete firewall.${WG_IF}
uci -q delete firewall.lan_${WG_IF}
uci -q delete firewall.${WG_IF}_lan
uci -q delete firewall.guest_${WG_IF}
uci -q delete firewall.${WG_IF}_guest
uci commit firewall
/etc/init.d/firewall restart
