# OPEN VPN

## Intall vpn server
    curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    chmod +x openvpn-install.sh
    ./openvpn-install.sh
    ls
    cat testnet.ovpn  (*)
## Install client
    apt install openvpn -y
    nano /etc/openvpn/main.conf
    
1\ paste data from (*)

    systemctl start openvpn@main.service
2\ check log
    systemctl log openvpn@main.service
