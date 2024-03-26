# Fivem-Proxy-Install.sh
Handy script to install nginx as a proxy for your FiveM/RedM server.



## Requirements
- Debian linux distribution (Tested on debian 10/11/12) - minimal only (not a self installed variant)
- Root access
- A domain name
- A FiveM/RedM server

## Installation
1. clone this repo
2. nano the install script `nano /Fivem-Proxy-Install.sh/fivem-nginx-proxy-install.sh`
3. Find the ACME registration details and update with your email (it will usually be youremail@example.com)
4. Make it executable: `chmod +x fivem-nginx-proxy-install.sh`
5. Run it: `./fivem-nginx-proxy-install.sh`

## Usage
1. Follow the instructions
2. Append the following into your sv.cfg
   
---your other config---

sv_endpointprivacy true

set sv_requestParanoia 3 

set sv_forceIndirectListing true

set sv_listingHostOverride "subdomain.domain.com" --of your proxy

set sv_proxyIPRanges "IPProxy/32"

set sv_endpoints "IPProxy:30120"

set net_tcpconnlimit 10000

---End of config---


3. Enjoy your new proxy!

## Common issue on debian 12 and ubuntu 20.04
If your nginx errors out and gives an output stating that it could not rebind ports to 30120, instead of running `sudo systemctl restart nginx` run `sudo pkill -f nginx & wait $!` then `sudo systemctl start nginx`

## Credits
- [Nginx](https://nginx.org/)
- [Certbot](https://certbot.eff.org/)
- [Let's Encrypt](https://letsencrypt.org/)
- [FiveM](https://fivem.net/)
- [RedM](https://redm.gg/)
- [MathiAs2Pique](https://github.com/MathiAs2Pique)

###Credit to the original author and thanks to his help https://github.com/MathiAs2Pique/Fivem-Proxy-Install.sh/commits?author=MathiAs2Pique
### Ad
## Why ? 
As I own [purplemaze](https://purplemaze.net), an anti-DDoS protection for FiveM, I needed to generate some proxy by hand, and I thought it would be a good idea to automate the process.  
Additionally, some people were asking me how to do it, so I decided to make a script to help them.  
**Feel free to DM me on Discord for help: @m2p_**  
If you want a strong protection with more than a year of experience and constantly updated, you can check out [PurpleMaze](https://purplemaze.net).  
[![PurpleMaze](https://cdn.discordapp.com/attachments/859400057564561408/1092897682344923249/purplemazeLogo.png)](https://discord.gg/RThBYA5fAD)

## Additional notes
- I personnaly recommend to use CloudFlare: DNS, Proxy and Edge Cache are really useful.
- Please do not use the built-in nginx cache, as it's a mess if you want to udpate your scripts, and it would cost you a lot more than CloudFlare.
- If you have your own SSL certificate, then just check web.conf to edit what needs to be edited.
- If you want to use a custom port, then just check web.conf to edit what needs to be edited.
- A **single** proxy is **not useful at all** as a DDoS protection, but it can be useful to hide your IP address.
