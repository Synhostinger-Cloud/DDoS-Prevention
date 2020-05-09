#
#   _____             _               _   _
#  / ____|           | |             | | (_)
# | (___  _   _ _ __ | |__   ___  ___| |_ _ _ __   __ _  ___ _ __
#  \___ \| | | | '_ \| '_ \ / _ \/ __| __| | '_ \ / _` |/ _ \ '__|
#  ____) | |_| | | | | | | | (_) \__ \ |_| | | | | (_| |  __/ |
# |_____/ \__, |_| |_|_| |_|\___/|___/\__|_|_| |_|\__, |\___|_|
#          __/ |                                   __/ |
#         |___/                                   |___/
#
# 			By Bastien LANGUEDOC
#			Prevention attack DDoS

echo ""
echo "⛔️ Attention droit root obligatoire ⛔️ "
echo "⛔️ Cela n'empêchera pas une attaque DDoS ⛔️ "
echo ""
echo "-------------------------------------"
echo   "Appuiez entrer pour continuer..."
echo "-------------------------------------"
read -p ""
echo "Exécution du script en cours..."
##############################################################################
iptables -A INPUT   -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A INPUT   -m recent --name portscan --remove
iptables -A FORWARD -m recent --name portscan --remove
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
###################################################################################
echo "-------------------------------------"
echo   "Appuiez entrer pour quitter..."
echo "-------------------------------------"
read -p ""