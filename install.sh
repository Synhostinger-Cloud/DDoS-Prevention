#!/bin/bash
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
#color
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
REDBG=$(tput setab 1)
GREENBG=$(tput setab 2)
YELLOWBG=$(tput setab 3)
BLUEBG=$(tput setab 4)
MAGENTABG=$(tput setab 5)
CYANBG=$(tput setab 6)
WHITEBG=$(tput setab 7)

#Supported systems:
supported="CentOS/RHEL Linux Debian Ubuntu"

cat << "EOF"
   _____             _               _   _
  / ____|           | |             | | (_)
 | (___  _   _ _ __ | |__   ___  ___| |_ _ _ __   __ _  ___ _ __
  \___ \| | | | '_ \| '_ \ / _ \/ __| __| | '_ \ / _` |/ _ \ '__|
  ____) | |_| | | | | | | | (_) \__ \ |_| | | | | (_| |  __/ |
 |_____/ \__, |_| |_|_| |_|\___/|___/\__|_|_| |_|\__, |\___|_|
          __/ |                                   __/ |
         |___/                                   |___/

EOF
# Root Force
if [ "$(id -u)" != "0" ]; then
        printf "${RED}⛔️ Attention droit root obligatoire ⛔️\\n" 1>&2
        printf "\\n"
        exit 1
fi
    printf "${RED}⛔️ Protection pour VPS / Dédié ⛔️\\n"
    printf "${RED}⛔️ Réduction de l'attaque DDoS ⛔️\\n"
    printf "\\n"
    printf "${WHITE} - Les règles avec des couleurs\\n"
    printf "\\n"
    printf "${RED} - Vivement recommandé\\n"
    printf "${YELLOW} - Recommandé\\n"
    printf "${GREEN} - Facultatif\\n"
    printf "\\n"
    printf "${WHITE}OS:${MAGENTA} $supported \\n"
    printf "${CYAN}\\n"
    echo "-------------------------------------"
    printf "Appuiez entrer pour continuer...\\n"
    echo "-------------------------------------"
    read -p ""
    printf "Exécution du script en cours...\\n"
#############################################################################
#Pour la prochaine version !
mkdir -p /var/synhostinger/  > /dev/null 2>&1
printf "${RED} Souhaitez-vous bloquer les paquets avec de faux drapeaux TCP ❓ [o/N]\\n"
read reponse
if [[ "$reponse" == "o" ]]
    then 
        printf "${CYAN} Parfait les règles sont activent !"
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
        /sbin/iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
fi
echo
    printf "${BLUE} Avez-vous un serveur SSH ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
    printf "${RED} Souhaitez-vous bloquer le SSH Brute-Force ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then
        printf "${CYAN} Parfait les règles sont activent !"
        /sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
        /sbin/iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
fi
fi
echo
    printf "${YELLOW} Souhaitez-vous bloquer le Scan Port ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
        printf "${CYAN} Parfait les règles sont activent !"
        /sbin/iptables -A INPUT   -m recent --name portscan --rcheck --seconds 86400 -j DROP
        /sbin/iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP
        /sbin/iptables -A INPUT   -m recent --name portscan --remove
        /sbin/iptables -A FORWARD -m recent --name portscan --remove
fi
echo
    
    printf "${YELLOW} Souhaitez-vous bloquer les paquets invalides ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
    printf "${CYAN} Parfait la règle est active !"
    /sbin/iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
fi
echo
    printf "${YELLOW} Souhaitez-vous bloquer les fragments dans toutes les chaînes ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
    printf "${CYAN} Parfait la règle est active !"
    /sbin/iptables -t mangle -A PREROUTING -f -j DROP
fi
echo
    printf "${YELLOW} Souhaitez-vous limiter les connexions par IP source ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
    printf "${CYAN} Parfait la règle est active !"
    /sbin/iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset
fi
echo
    printf "${GREEN} Souhaitez-vous bloquer ICMP ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then 
    printf "${CYAN} Parfait la règle est active !"
    /sbin/iptables -t mangle -A PREROUTING -p icmp -j DROP
fi
echo
    printf "${YELLOW} Souhaitez-vous limiter les connexions par IP source ❓ [o/N]\\n"
    read reponse
if [[ "$reponse" == "o" ]]
then
    printf "${BLUE} Combien de connexion ❓ [1-9999]\\n"
    read number
if [[ $number == ?(-)+([0-9]) ]]
then
        printf "${CYAN} Parfait la règle est active !"
        /sbin/iptables -A INPUT -p tcp -m connlimit --connlimit-above $number -j REJECT --reject-with tcp-reset
else
    echo "${RED} Erreur vous avez écrit : $number"
    read -p "Combien de connexion ❓ [1-9999] " number
    printf "${CYAN} Parfait la règle est active !"
    /sbin/iptables -A INPUT -p tcp -m connlimit --connlimit-above $number -j REJECT --reject-with tcp-reset
fi
fi
