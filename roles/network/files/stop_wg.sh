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

uci -q delete firewall.lan_forward_wan
uci set firewall.lan_forward_wan="forwarding"
uci set firewall.lan_forward_wan.src="lan"
uci set firewall.lan_forward_wan.dest="wan"

uci -q delete firewall.guest_forward_wan
uci set firewall.guest_forward_wan="forwarding"
uci set firewall.guest_forward_wan.src="guest"
uci set firewall.guest_forward_wan.dest="wan"

uci -q delete firewall.wan_forward_lan
uci set firewall.wan_forward_lan="forwarding"
uci set firewall.wan_forward_lan.src="wan"
uci set firewall.wan_forward_lan.dest="lan"

uci -q delete firewall.wan_forward_guest
uci set firewall.wan_forward_guest="forwarding"
uci set firewall.wan_forward_guest.src="wan"
uci set firewall.wan_forward_guest.dest="guest"

uci commit firewall
/etc/init.d/firewall restart
