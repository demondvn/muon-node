# VPS

    curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    chmod +x openvpn-install.sh
    ./openvpn-install.sh 
- select tcp > enter enter
-

    ls
    cat testnet.ovpn (*)



## Client
        apt-get update
        sudo apt install openvpn -y
        sudo nano /etc/openvpn/<name> 
- paste data from (*)
        
        systemctl start openvpn@<name>
        
## Check IP
    curl https://ipinfo.io/ip
# Stake and install muon

https://docs.muon.net/muon-network/muon-nodes/joining-the-testnet-alice
