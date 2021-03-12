#!/bin/bash

LOGFILE="network-debug-$RANDOM.log"

echo "========================================"
echo "Printing network debug logs to $LOGFILE"

echo -en "\n\n # ip addr -> \n" >> $LOGFILE
ip addr >> $LOGFILE

echo -en "\n\n # ip link show -> \n" >> $LOGFILE
ip link show >> $LOGFILE

echo -en "\n\n # ip neighbor show -> \n" >> $LOGFILE
ip neighbor show >> $LOGFILE

echo -en "\n\n # ip -br address show -> \n" >> $LOGFILE
ip -br address show >> $LOGFILE

echo -en "\n\n # ip route show -> \n" >> $LOGFILE
ip route show >> $LOGFILE

echo -en "\n\n # cat /etc/resolv.conf -> \n" >> $LOGFILE
sudo cat /etc/resolv.conf >> $LOGFILE

echo -en "\n\n # ss -tunlp4  -> \n" >> $LOGFILE
ss -tunlp4  >> $LOGFILE

echo -en "\n\n # iptables -L -> \n" >> $LOGFILE
sudo iptables -L >> $LOGFILE


echo "Networking information printed to $LOGFILE"
echo "-------------------------------------------------"