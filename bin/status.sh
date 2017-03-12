#!/bin/bash


pi_status() {
    send_cmd() {
        ssh -t pi-2 $@ 2> /dev/null
    }
    drives="/media/journal1
    /media/journal2
    /media/journal3"
    for drive in $drives; do
        if send_cmd grep -qs $drive /proc/mounts; then
            echo "$drive is mounted"
        else
            echo "...$drive is not mounted"
        fi

    done
    if [ -z $(send_cmd pgrep deluge) ]; then
        echo "...deluge is not running"
    else
        echo "deluge is running"
    fi

}
network_status() {
    speedtest-cli --simple
    ktorrent="$(lsof -i | grep ktorrent)"
    [ $? -eq 0 ] && echo "ktorrent is running"
    # find number of devices on network (need to quantify)
    #sudo arp-scan --interface=wlan1 --localnet
}
#comp_status() {

#}


case $1 in
    p)
        echo "pi status:"
        echo "=========="
        pi_status
        ;;
    n)
        echo "network status:"
        echo "==============="
        network_status
        ;;
    c)
        echo "system status:"
        echo "=============="
        comp_status
        ;;
    *)
        echo "usage: status.sh [p | n | c]"
        exit 1
        ;;
esac
