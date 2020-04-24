#! /bin/bash
export PATH=$PATH:/mnt/d/Code/Joy/joy-master/bin

if [ ! -d $1-tls-flows ]; then
	mkdir $1-tls-flows
fi

for stream in `tshark -r $1 -Y tls -T fields -e tcp.stream | sort -n | uniq`
do
    echo "Extract meta informaion from TLS flow $stream"
    tshark -r $1 -F pcap -w $1-tls-$stream.pcap -2 -R "tcp.stream==$stream"
    tshark -r $1-tls-$stream.pcap -T fields -c 1 -e ip.dst >  $1-tls-$stream.ip-names.txt
   	grep -f $1-tls-$stream.ip-names.txt $2 | awk '{print $2}'| awk 'BEGIN{ FS=","} {for( i=1; i<=NF; i++) print $i}' >>  $1-tls-$stream.ip-names.txt
    joy output=$1-tls-$stream.json bidir=1 num_pkts=200 ppi=0 zeros=1 $1-tls-$stream.pcap
    bro -C -r $1-tls-$stream.pcap
    mv ssl.log $1-tls-$stream.ssl.log
    mv x509.log $1-tls-$stream.x509.log
    mv $1-tls-$stream.* $1-tls-flows
done
rm conn.log
rm files.log
rm packet_filter.log

