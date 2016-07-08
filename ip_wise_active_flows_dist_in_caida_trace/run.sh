#!/usr/bin/bash

IP="$1"
#file="$2"
logfile1=af100-$(echo $IP | sed -e 's/\./-/g').log
logfile2=af300-$(echo $IP | sed -e 's/\./-/g').log

OUT=$(mktemp /tmp/mraj.XXXXX)

#tcpdump -r $file -w $OUT dest $IP
tcpdump -r  ~/my_project_work/RITE/caida_data/2008/dirB/20081218/equinix-sanjose.dirB.20081218-125904.UTC.anon.pcap -w $OUT dst $IP

./af100 pcap:$OUT > test_run/$logfile1
./af300 pcap:$OUT > test_run/$logfile2

