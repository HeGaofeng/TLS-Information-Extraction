#! /bin/bash
export PATH=$PATH:/mnt/d/Code/Joy/joy-master/bin

if [ ! -d $1-tls-flows ]; then
	mkdir $1-tls-flows
fi

cp $1 $1-tls-flows
mv $2 $1-tls-flows

cd $1-tls-flows

for stream in `tshark -r $1 -Y tls -T fields -e tcp.stream | sort -n | uniq`
do
    echo "Extract meta informaion from TLS flow $stream"
    tshark -r $1 -F pcap -w $1-tls-$stream.pcap -2 -R "tcp.stream==$stream"
    tshark -r $1-tls-$stream.pcap -T fields -c 1 -e ip.dst >  $1-tls-$stream.ip-names.txt
   	#find out all server_names(CNAMEs) for ip.dst
   	grep -f $1-tls-$stream.ip-names.txt $2 | awk '{print $2}'| awk 'BEGIN{ FS=","} {for( i=1; i<=NF; i++) print $i}' >>  $1-tls-$stream.ip-names.txt
    #use jor to obtain the first 200 packets' sizes and time intervals
    joy output=$1-tls-$stream.json bidir=1 num_pkts=200 ppi=0 zeros=1 $1-tls-$stream.pcap
   	#use bro to obtain ssl and x.509 information
    bro -C -r $1-tls-$stream.pcap
    	
   	if [ -f "ssl.log" ]; then 
   		mv ssl.log $1-tls-$stream.ssl.log
   	fi
    if [ -f "x509.log" ]; then
    	mv x509.log $1-tls-$stream.x509.log
    fi
done

#rm files.log
#rm packet_filter.log

