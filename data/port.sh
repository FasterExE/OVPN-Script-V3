#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
# // Exporting Language to UTF-8

export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'


# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

TCP=$(cat /etc/allport/tcp)
UDP=$(cat /etc/allport/udp)
WS=$(cat /etc/allport/ws)
SSL=$(cat /etc/allport/ssl)

function tcp() {
clear
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "                  ${BIWhite}${UWhite}OVPN TCP PROT${NC}${BIPurple} ($TCP)${NC} "
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
invalid_ports=($TCP $UDP $WS $SSL 81 89 22 53)
is_invalid_port() {
    local port=$1
    for invalid_port in "${invalid_ports[@]}"; do
        if [ "$port" -eq "$invalid_port" ]; then
            return 0
        fi
    done
    return 1
}


while true; do
    echo -ne "   ${BIGreen}Enter New Port: ${NC}"
    read porttcp

    if [[ "$porttcp" =~ ^[0-9]+$ ]]; then
        if ! is_invalid_port "$porttcp"; then
            echo -e "   ${BIGreen}Valid port: $porttcp ✅${NC}"
            break
        else
            echo -e "   ${BIRed}port already used.${NC}"
        fi
    else
        echo -e "   ${BIRed}Invalid input, please enter a number.${NC}"
    fi
done

mkdir /etc/allport > /dev/null 2>&1
rm /etc/allport/tcp
echo $porttcp >> /etc/allport/tcp
sudo sed -i "3s/.*/port $porttcp/" /etc/openvpn/server2.conf
sudo systemctl restart openvpn@server2
read -n 1 -s -r -p "  Press any key to back on menu"
clear
port
}

function udp() {
clear
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "                  ${BIWhite}${UWhite}OVPN UDP PROT${NC}${BIPurple} ($UDP)${NC} "
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
invalid_ports=($TCP $UDP $WS $SSL 81 89 22 53)
is_invalid_port() {
    local port=$1
    for invalid_port in "${invalid_ports[@]}"; do
        if [ "$port" -eq "$invalid_port" ]; then
            return 0
        fi
    done
    return 1
}


while true; do
    echo -ne "   ${BIGreen}Enter New Port: ${NC}"
    read portudp

    if [[ "$portudp" =~ ^[0-9]+$ ]]; then
        if ! is_invalid_port "$portudp"; then
            echo -e "   ${BIGreen}Valid port: $portudp ✅${NC}"
            break
        else
            echo -e "   ${BIRed}port already used.${NC}"
        fi
    else
        echo -e "   ${BIRed}Invalid input, please enter a number.${NC}"
    fi
done

mkdir /etc/allport > /dev/null 2>&1
rm /etc/allport/udp
echo $portudp >> /etc/allport/udp
sudo sed -i "3s/.*/port $portudp/" /etc/openvpn/server.conf
sudo systemctl restart openvpn@server
read -n 1 -s -r -p "  Press any key to back on menu"
clear
port
}

function ws() {
clear
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "                 ${BIWhite}${UWhite}WEBSOCKET PROT${NC}${BIPurple} ($WS)${NC} "
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
invalid_ports=($TCP $UDP $WS $SSL 81 89 22 53)
is_invalid_port() {
    local port=$1
    for invalid_port in "${invalid_ports[@]}"; do
        if [ "$port" -eq "$invalid_port" ]; then
            return 0
        fi
    done
    return 1
}


while true; do
    echo -ne "   ${BIGreen}Enter New Port: ${NC}"
    read portws

    if [[ "$portws" =~ ^[0-9]+$ ]]; then
        if ! is_invalid_port "$portws"; then
            echo -e "   ${BIGreen}Valid port: $portws ✅${NC}"
            break
        else
            echo -e "   ${BIRed}port already used.${NC}"
        fi
    else
        echo -e "   ${BIRed}Invalid input, please enter a number.${NC}"
    fi
done

mkdir /etc/allport > /dev/null 2>&1
rm /etc/allport/ws
echo $portws >> /etc/allport/ws
sudo sed -i "11s#.*#ExecStart=/usr/bin/python -O /usr/local/bin/ws-ovpn $portws#" /etc/systemd/system/ws-ovpn.service
sudo systemctl daemon-reload
sudo systemctl restart ws-ovpn
read -n 1 -s -r -p "  Press any key to back on menu"
clear
port
}

function ssl() {
clear
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "                   ${BIWhite}${UWhite}STUNNEL PROT${NC}${BIPurple} ($SSL)${NC} "
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
invalid_ports=($TCP $UDP $WS $SSL 81 89 22 53)
is_invalid_port() {
    local port=$1
    for invalid_port in "${invalid_ports[@]}"; do
        if [ "$port" -eq "$invalid_port" ]; then
            return 0
        fi
    done
    return 1
}


while true; do
    echo -ne "   ${BIGreen}Enter New Port: ${NC}"
    read portssl

    if [[ "$portssl" =~ ^[0-9]+$ ]]; then
        if ! is_invalid_port "$portssl"; then
            echo -e "   ${BIGreen}Valid port: $portssl ✅${NC}"
            break
        else
            echo -e "   ${BIRed}port already used.${NC}"
        fi
    else
        echo -e "   ${BIRed}Invalid input, please enter a number.${NC}"
    fi
done

mkdir /etc/allport > /dev/null 2>&1
rm /etc/allport/ssl
echo $portssl >> /etc/allport/ssl
sudo sed -i "6s/.*/accept = $portssl/" /etc/stunnel/stunnel.conf
sudo systemctl restart stunnel4
read -n 1 -s -r -p "  Press any key to back on menu"
clear
port
}

clear
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "                     ${BIWhite}${UWhite}SERVICE PROT${NC} "
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "     ${BICyan}[${BIWhite}01${BICyan}] Change OpenVPN TCP Port ${BIPurple}($TCP)${NC}"
echo -e "     ${BICyan}[${BIWhite}02${BICyan}] Change OpenVPN UDP Port ${BIPurple}($UDP)${NC}"
echo -e "     ${BICyan}[${BIWhite}03${BICyan}] Change Websocket Port ${BIPurple}($WS)${NC}"
echo -e "     ${BICyan}[${BIWhite}04${BICyan}] Change Stunnel Port ${BIPurple}($SSL)${NC}"
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
echo -e "     ${BIYellow}Press x or [ Ctrl+C ] • To-${BIWhite}Exit${NC}"
echo ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in

1)
tcp
;;
2)
udp
;;
3)
ws
;;
4)
ssl
;;
*)
clear
;;
esac