# configure-vpn.sh
sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt autoremove -y

sudo apt install strongswan -y

sudo cp /etc/ipsec.conf /etc/ipsec.conf.bak

sudo cp /etc/ipsec.secrets /etc/ipsec.secrets.bak

sudo sed -i '$ a\net.ipv4.ip_forward = 1\nnet.ipv4.conf.all.rp_filter=0\nnet.ipv4.conf.eth0.rp_filter=0' /etc/sysctl.conf

sudo sysctl -p /etc/sysctl.conf

sudo /etc/init.d/procps restart

#sudo sed -i '$ a ONPREM-GW-PUB AZURE-GW-PUB : PSK secret123' /etc/ipsec.secrets

sudo sed -i '$ a 51.141.118.31 52.151.73.9 : PSK secret123' /etc/ipsec.secrets

sudo sed -e '/config/ s/^#*/#/' -i /etc/ipsec.conf

sudo tee -a /etc/ipsec.conf > /dev/null <<'EOF'
conn Azure
         dpdaction=restart
         ike=aes256-sha1-modp1024
         esp=aes256-sha1
         keyexchange=ikev2
         ikelifetime=28800s
         keylife=3600s
         authby=secret
         # Ubuntu VM Internal DMZ IP
         left=192.168.0.4
         # Ubuntu VM Internal DMZ IP
         leftid=192.168.0.4
         # OnPrem Address Space
         leftsubnet=192.168.0.0/16
         # Azure VPN Gateway Public IP
         right=52.151.73.9
         # Azure VPN Gateway Public IP
         rightid=52.151.73.9
         # CLOUD-VNET Address Spaces
         rightsubnet=10.10.0.0/16
         auto=start
EOF

sudo ipsec restart

