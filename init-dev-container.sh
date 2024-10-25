test -f /root/.ssh || mkdir -p /root/.ssh ; chmod 700 /root/.ssh
test -f ${PERSISTENT_DATA_DIR}/id_ecdsa || ssh-keygen -t ecdsa -b 521 -N '' -f ${PERSISTENT_DATA_DIR}/id_ecdsa
test -f /root/.ssh/id_ecdsa || ln -sf ${PERSISTENT_DATA_DIR}/id_ecdsa /root/.ssh/id_ecdsa

export LC_ALL="C"
export PATH=$PATH:/usr/games

set -a
source ${ENV_CONFIG}
set +a

alias ppk="cat ${PERSISTENT_DATA_DIR}/id_ecdsa.pub"
alias vpn-status='(ping -q -w 2 -c 3 gw >/dev/null && echo "VPN is up.") || echo "VPN is down."'
alias vpn-up="openvpn --config ${OPENVPN_CONFIG} --dev tun --daemon ; sleep 5 ; vpn-status"
alias vpn-down='pkill openvpn'
alias help="cat /etc/help.txt | cowsay -n | lolcat"

help
