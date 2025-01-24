# Fivem-Proxy-Install.sh
Handy script to install nginx as a proxy for your FiveM/RedM server.

## Why ?
As I own [purplemaze](https://purplemaze.net), an anti-DDoS protection for FiveM, I needed to generate some proxy by hand, and I thought it would be a good idea to automate the process.  
Additionally, some people were asking me how to do it, so I decided to make a script to help them.  
**Feel free to DM me on Discord for help: @m2p_**  

## Requirements
- Debian linux distribution (Tested on debian 10/11)
- Root access
- A domain name
- A FiveM/RedM server

## Installation
1. Download the script
2. Make it executable: `chmod +x fivem-proxy-install.sh`
3. Run it: `./fivem-proxy-install.sh`
4. If you're using CloudFlare, you may need to include cloudflare.conf from your nginx.conf, in order to get the real players IP addresses.

## Usage
1. Follow the instructions
2. Enjoy your new proxy!

## Credits
- [Nginx](https://nginx.org/)
- [Certbot](https://certbot.eff.org/)
- [Let's Encrypt](https://letsencrypt.org/)
- [FiveM](https://fivem.net/)
- [RedM](https://redm.gg/)
- [Me](https://github.com/MathiAs2Pique)

### Ad

If you want a strong protection with more than a year of experience and constantly updated, you can check out [PurpleMaze](https://purplemaze.net).  
[![PurpleMaze](https://purplemaze.net/img/logo.png)](https://discord.gg/RThBYA5fAD)

## Additional notes
- I personnaly recommend to use CloudFlare: DNS, Proxy and Edge Cache are really useful.
- Please do not use the built-in nginx cache, as it's a mess if you want to udpate your scripts, and it would cost you a lot more than CloudFlare.
- If you have your own SSL certificate, then just check web.conf to edit what needs to be edited.
- If you want to use a custom port, then just check web.conf to edit what needs to be edited.
- A **single** proxy is **not useful at all** as a DDoS protection, but it can be useful to hide your IP address.
