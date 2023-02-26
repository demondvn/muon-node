#!/bin/sh
config_file=$(find /config -name '*.conf' -o -name '*.ovpn' 2> /dev/null | sort | shuf -n 1)
if [[ -z $config_file ]]; then
    echo "no openvpn configuration file found" >&2
    exit 1
fi
openvpn "/openvpn/$config_file" --dev tun