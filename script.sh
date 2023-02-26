#!/bin/sh
config_file=$(find /openvpn -name '*.conf' -o -name '*.ovpn' 2> /dev/null | sort | shuf -n 1)
if [[ -z $config_file ]]; then
    echo "no openvpn configuration file found" >&2
    exit 1
fi
echo "run with config file $config_file"
ip tuntap show
openvpn --config "$config_file" --dev tun