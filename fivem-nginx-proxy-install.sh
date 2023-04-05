# Install Nginx Proxy for FiveM
clear

# Check OS Version (Debian, Ubuntu, ...)
if [ -f /etc/debian_version ]; then
    OS=debian
elif [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
    OS=centos
else
    echo "Ew, this script only supports Debian, Ubuntu, CentOS and Fedora."
    exit
fi

# Check if user has root privileges
if [ "$(id -u)" != "0" ]; then
    echo "Ew, this script must be run as root" 1>&2
    exit 1
fi

# Install Nginx
if [ "$OS" == "debian" ]; then
    # Add Nginx repository
    echo -e "\n\e[35m"
    echo "Adding Nginx repository..."
    echo -e "\e[0m"
    # Before, check if the repo. is already in the sources.
    if grep -q "nginx.org" /etc/apt/sources.list; then
        echo "Nginx repository already added."
    else
        echo "deb http://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list
        echo "deb-src http://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list
        wget http://nginx.org/keys/nginx_signing.key 
        apt-key add nginx_signing.key 
        rm nginx_signing.key
    fi
    # Install it
    echo -e "\n\e[35m"
    echo "Installing Nginx..."
    echo -e "\e[0m"
    apt-get update 
    apt-get install -y nginx psmisc 
elif [ "$OS" == "centos" ]; then
    # Add Nginx repository
    echo -e "\n\e[35m"
    echo "Adding Nginx repository..."
    echo -e "\e[0m"
    rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm 
    # Install it
    echo -e "\n\e[35m"
    echo "Installing Nginx..."
    echo -e "\e[0m"
    yum install -y epel-release 
    yum install -y nginx psmisc
fi

rm -rf /etc/nginx/conf.d
mkdir -p /etc/nginx/ssl

# User input now!
echo -e "\n\e[35m"
echo "Please enter the IP address (with the port) of your server (Ex: 1.1.1.1:30120)"
read -p "IP Address: " ip
echo "Please enter the domain name of your server (Ex: play.purplemaze.xyz)"
read -p "Domain Name: " domain
echo "Do you want to auto generate a SSL certificate? (You'll need one, but type 'n' if you're importing one by yourself.) (y/n)"
read -p "Auto Generate SSL: " ssl
echo -e "\e[0m"

# Install python-certbot-nginx
echo -e "\n\e[35m"
echo "Installing certbot..."
echo -e "\e[0m"
if [ "$ssl" == "y" ]; then
    if [ "$OS" == "debian" ]; then
        apt-get install -y python3-certbot-nginx 
    elif [ "$OS" == "centos" ]; then
        yum install -y certbot-nginx 
    fi
fi

# Download Nginx configs
echo -e "\n\e[35m"
echo "Downloading Nginx configs..."
echo -e "\e[0m"
wget https://github.com/MathiAs2Pique/Fivem-Proxy-Install.sh/raw/main/files/nginx.conf -O /etc/nginx/nginx.conf 
wget https://github.com/MathiAs2Pique/Fivem-Proxy-Install.sh/raw/main/files/stream.conf -O /etc/nginx/stream.conf 
wget https://github.com/MathiAs2Pique/Fivem-Proxy-Install.sh/raw/main/files/web.conf -O /etc/nginx/web.conf 

# Replace placeholders
echo -e "\n\e[35m"
echo "Replacing placeholders..."
echo -e "\e[0m"
sed -i "s/ip_goes_here/$ip/g" /etc/nginx/nginx.conf
sed -i "s/ip_goes_here/$ip/g" /etc/nginx/stream.conf
sed -i "s/server_name_goes_here/$domain/g" /etc/nginx/web.conf

# Generate SSL certificate
if [ "$ssl" == "y" ]; then
    echo -e "\n\e[35m"
    echo "We'll now generate a SSL certificate for your domain."
    echo "PLEASE ensure that you have a DNS record pointing to this server's IP address. (Deactivate Cloudflare's proxys if you're using it.)"
    read -p "Press enter to continue..."
    echo -e "\e[0m"

    echo -e "\n\e[35m"
    echo "Generating SSL certificate..."
    echo -e "\e[0m"
    killall nginx
    certbot certonly --nginx -d $domain --non-interactive --agree-tos --email trash@purplemaze.xyz
    # Copy files to /etc/nginx/ssl
    echo -e "\n\e[35m"
    echo "Copying SSL files..."
    echo -e "\e[0m"
    cp /etc/letsencrypt/live/$domain/fullchain.pem /etc/nginx/ssl/fullchain.pem
    cp /etc/letsencrypt/live/$domain/privkey.pem /etc/nginx/ssl/privkey.pem
    # Replace placeholders
    echo -e "\n\e[35m"
    echo "Replacing placeholders..."*
    echo -e "\e[0m"
    sed -i "s/listen 80;/listen 443 ssl http2;/g" /etc/nginx/web.conf
    sed -i "s/# ssl_certificate/ssl_certificate/g" /etc/nginx/web.conf
    sed -i "s/# ssl_certificate_key/ssl_certificate_key/g" /etc/nginx/web.conf
fi

# Enable Nginx
echo -e "\n\e[35m"
echo "Enabling Nginx..."
echo -e "\e[0m"
killall nginx
systemctl enable nginx 
systemctl start nginx 

echo "Done! You can now connect to your server using connect https://$domain"
echo "Check out the server.cfg on the repo to see how to configure your server."

# Ad for my project
echo -e "\n\n\e[35m"
echo "If you want a realiable DDoS protection for your server"
echo "To get the msot out of your server and to protect it from DDoS attacks"
echo "Check out PurpleMaze, the most advanced algorithmic-based DDoS protection"
echo -e "\e[31m"
echo "https://purplemaze.xyz"
echo "https://discord.gg/BMJJWjZafv"
echo -e "\e[0m"

exit 0