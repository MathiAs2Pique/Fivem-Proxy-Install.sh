#!/bin/bash

# Improved OS detection
OS="unknown"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
fi

# root ?
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Install nginx
install_nginx() {
    case $1 in
        debian|ubuntu)
            apt-get update
            apt-get install -y gnupg2 lsb-release software-properties-common
            OS_CODENAME=$(lsb_release -cs)
            echo "deb http://nginx.org/packages/mainline/debian/ $OS_CODENAME nginx" | tee /etc/apt/sources.list.d/nginx.list
            echo "deb-src http://nginx.org/packages/mainline/debian/ $OS_CODENAME nginx" | tee -a /etc/apt/sources.list.d/nginx.list
            wget -qO - http://nginx.org/keys/nginx_signing.key | apt-key add -
            ;;

        centos|fedora|rhel)
            yum install -y epel-release
            yum-config-manager --add-repo http://nginx.org/packages/mainline/centos/7/x86_64/
            wget -qO - http://nginx.org/keys/nginx_signing.key | rpm --import -
            ;;
        *)
            # Unknown os :(
            echo "Unsupported OS: $1"
            exit 1
            ;;
    esac

    apt-get update || yum update
    apt-get install -y nginx || yum install -y nginx
    systemctl enable nginx
    systemctl start nginx
}

install_nginx $OS

# Clear previous Nginx configurations
rm -rf /etc/nginx/conf.d
mkdir -p /etc/nginx/ssl

# Inputs
echo -e "\nPlease enter the IP address (with the port) of your server (Ex: 1.1.1.1:30120)"
read -p "IP Address: " ip
echo "Please enter the domain name of your server (Ex: play.myserver.com)"
read -p "Domain Name: " domain
echo "Do you want to auto-generate an SSL certificate? (y/n)"
read -p "Auto Generate SSL: " ssl

# Install certbot for SSL (if needed)
if [ "$ssl" == "y" ]; then
    if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
        apt-get install -y python3-certbot-nginx 
    elif [ "$OS" == "centos" ] || [ "$OS" == "fedora" ] || [ "$OS" == "rhel" ]; then
        yum install -y certbot-nginx 
    fi
fi

# Download Nginx configuration files
wget https://github.com/MathiAs2Pique/Fivem-Proxy-Install.sh/raw/main/files/nginx.conf -O /etc/nginx/nginx.conf 
wget https://github.com/MathiAs2Pique/Fivem-Proxy-Install.sh/raw/main/files/stream.conf -O /etc/nginx/stream.conf 
wget https://github.com/MathiAs2Pique/Fivem-Proxy-Install.sh/raw/main/files/web.conf -O /etc/nginx/web.conf 

# Replace placeholders in conf files
sed -i "s/ip_goes_here/$ip/g" /etc/nginx/nginx.conf
sed -i "s/ip_goes_here/$ip/g" /etc/nginx/stream.conf
sed -i "s/server_name_goes_here/$domain/g" /etc/nginx/web.conf

# Generate SSL certificate (if needed)
if [ "$ssl" == "y" ]; then
    echo -e "\nGenerating SSL certificate..."
    systemctl stop nginx
    certbot certonly --nginx -d $domain --non-interactive --agree-tos --register-unsafely-without-email
    # Copy certificate files
    cp /etc/letsencrypt/live/$domain/fullchain.pem /etc/nginx/ssl/fullchain.pem
    cp /etc/letsencrypt/live/$domain/privkey.pem /etc/nginx/ssl/privkey.pem
    # Adjust web.conf for SSL
    sed -i "s/listen 80;/listen 443 ssl;\n http2 on;/g" /etc/nginx/web.conf
    sed -i "s/# ssl_certificate/ssl_certificate/g" /etc/nginx/web.conf
    sed -i "s/# ssl_certificate_key/ssl_certificate_key/g" /etc/nginx/web.conf
fi

# Restart Nginx
systemctl restart nginx 

echo "Done! You can now connect to your server using connect https://$domain"
echo "Check out the server.cfg on the repo to see how to configure your server."

# Ad for my project
echo -e "\n\n\e[35m"
echo "If you want a realiable DDoS protection for your server"
echo "To get the msot out of your server and to protect it from DDoS attacks"
echo "Check out PurpleMaze, the most advanced algorithmic-based DDoS protection"
echo -e "\e[31m"
echo "https://purplemaze.net"
echo "https://discord.gg/BMJJWjZafv"
echo -e "\e[0m"

exit 0
