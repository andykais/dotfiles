#/bin/bash

nloops=1
stat_path=$HOME/bin/data
> $stat_path/ping
> $stat_path/down
> $stat_path/uplo

while [ $nloops -ne 0 ]
do
    echo "start speedrun"
    raw_output=$(speedtest-cli --simple)
    echo raw_output
    ping_speed=${raw_output:0}
    down_speed=${raw_output:1}
    uplo_speed=${raw_output:2}

    echo stuff
    echo $ping_speed >> $stat_path/ping

    nloops=$(($nloops - 1 ))
done
