#!/bin/sh
export $(grep -v '#.*' /etc/config/mullvad | xargs)
WG_SERVERS=`curl https://api.mullvad.net/public/relays/wireguard/v1/`
if test $? -ne 0; then
  exit $?
fi
WG_SERVERS_FILTERED=`echo "$WG_SERVERS" | jq '[ .countries[] | select( .code != "au" and .code != "gb" and .code != "br" and .code != "us" and .code != "ca" and .code != "hk" and .code != "jp" and .code != "nz" and .code != "sg" ).cities[].relays[] ]'`
WG_SERVERS_LENGTH=`echo "$WG_SERVERS_FILTERED" | jq -r '. | length'`
SELECTED_WG_SERVER=`echo "$WG_SERVERS_FILTERED" | jq --arg i $(($RANDOM % $WG_SERVERS_LENGTH)) '.[$i | tonumber]'`
WG_SERV=`echo "$SELECTED_WG_SERVER" | jq -r '.ipv4_addr_in'`
WG_PUB=`echo "$SELECTED_WG_SERVER" | jq -r '.public_key'`
WG_IF="wg0"
WG_PORT="51820"

uci -q delete network.${WG_IF}
uci set network.${WG_IF}="interface"
uci set network.${WG_IF}.proto="wireguard"
uci set network.${WG_IF}.private_key="${WG_KEY}"
uci add_list network.${WG_IF}.addresses="${WG_ADDR}"
uci add_list network.${WG_IF}.addresses="${WG_ADDR6}"

uci -q delete network.wireguard_${WG_IF}
uci set network.wireguard_${WG_IF}="wireguard_${WG_IF}"
uci set network.wireguard_${WG_IF}.public_key="${WG_PUB}"
uci set network.wireguard_${WG_IF}.endpoint_host="${WG_SERV}"
uci set network.wireguard_${WG_IF}.endpoint_port="${WG_PORT}"
uci set network.wireguard_${WG_IF}.route_allowed_ips="1"
uci set network.wireguard_${WG_IF}.persistent_keepalive="0"
uci set network.wireguard_${WG_IF}.interval="5"
uci set network.wireguard_${WG_IF}.timeout="25"
uci add_list network.wireguard_${WG_IF}.allowed_ips="0.0.0.0/0"
uci add_list network.wireguard_${WG_IF}.allowed_ips="::/0"

uci commit network
/etc/init.d/network restart

uci -q delete firewall.${WG_IF}
uci set firewall.${WG_IF}="zone"
uci set firewall.${WG_IF}.name="WGZONE"
uci set firewall.${WG_IF}.input="REJECT"
uci set firewall.${WG_IF}.output="ACCEPT"
uci set firewall.${WG_IF}.forward="REJECT"
uci set firewall.${WG_IF}.masq="1"
uci set firewall.${WG_IF}.mtu_fix="1"
uci add_list firewall.${WG_IF}.device="${WG_IF}"

uci -q delete firewall.lan_${WG_IF}
uci set firewall.lan_${WG_IF}="forwarding"
uci set firewall.lan_${WG_IF}.src="lan"
uci set firewall.lan_${WG_IF}.dest="WGZONE"

uci -q delete firewall.${WG_IF}_lan
uci set firewall.${WG_IF}_lan="forwarding"
uci set firewall.${WG_IF}_lan.src="WGZONE"
uci set firewall.${WG_IF}_lan.dest="lan"

uci -q delete firewall.guest_${WG_IF}
uci set firewall.guest_${WG_IF}="forwarding"
uci set firewall.guest_${WG_IF}.src="guest"
uci set firewall.guest_${WG_IF}.dest="WGZONE"

uci -q delete firewall.${WG_IF}_guest
uci set firewall.${WG_IF}_guest="forwarding"
uci set firewall.${WG_IF}_guest.src="WGZONE"
uci set firewall.${WG_IF}_guest.dest="guest"

uci -q delete firewall.lan_forward_wan
uci -q delete firewall.guest_forward_wan
uci -q delete firewall.wan_forward_lan
uci -q delete firewall.wan_forward_guest

uci commit firewall
/etc/init.d/firewall restart
