test -f /root/.ssh || mkdir -p /root/.ssh ; chmod 700 /root/.ssh
cp -f ${PROJECT_DIR}/config/id_* /root/.ssh

export LC_ALL="C"
export PATH=$PATH:/usr/games

set -a
source ${ENV_CONFIG}
set +a

alias vpn-status='(ping -q -w 2 -c 3 gw >/dev/null && echo "VPN is up.") || echo "VPN is down."'
alias vpn-up="openvpn --config ${OPENVPN_CONFIG} --dev tun --daemon ; sleep 5 ; vpn-status"
alias vpn-down='pkill openvpn'
alias help="cat /etc/help.txt | cowsay -n | lolcat"

help
