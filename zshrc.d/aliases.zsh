myipv4() {
    ifconfig enp12s0 | grep "inet " | awk -F'[: ]+' '{ print $4 }'
}
alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
