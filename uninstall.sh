#!/bin/bash
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

project_path=`pwd`
project_domain=""
default_domain=`basename "$project_path"`

# get domain name
read -p "Your domain without protocol (example.com) or press Enter to use $default_domain: " project_domain

if [[ -z $project_domain ]]; then
    project_domain=$default_domain
fi

echo -n -e "Uninstall Gunicorn Service and Socket? ${GREEN}(N/y)${NC}? "
read answer
if [ "$answer" == "${answer#[YyДд]}" ] ;then
    exit
fi

echo -e "${BLUE}Uninstalling services...${NC}"

sudo service nginx stop
sudo systemctl disable gunicorn.${project_domain}
sudo systemctl stop gunicorn.${project_domain}

sudo rm .nginx/${project_domain}.conf
sudo rm .gunicorn/gunicorn.${project_domain}.service

sudo rm /etc/nginx/sites-enabled/${project_domain}.conf
# sudo rm /etc/systemd/system/gunicorn.${project_domain}.service
# sudo rm ${project_path}/.gunicorn/gunicorn.sock

sudo service nginx start
sudo systemctl daemon-reload

echo -e "${BLUE}Done...${NC}"

