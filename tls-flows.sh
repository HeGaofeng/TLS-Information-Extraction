#! /bin/bash
export PATH=$PATH:/mnt/d/Code/00\ EnryptedMalwareTrafficClassificaiton/my-TLSFeaturesExtraction

if [ ! $# == 1 ]; then
	echo "Usage: $0 path-of-pcap-files"
	exit
fi

#need quotes for $1 in case that the path contains spaces

if [ ! -d "$1" ]; then
	echo "$1 is not a folder"
	exit
fi

tmp_fifofile="/tmp/$$.fifo" 
mkfifo $tmp_fifofile
exec 1000<>$tmp_fifofile
rm -fr $tmp_fifofile

trap "exec 1000>&-;exec 1000<&-;exit 0" 2 #CTRL-C

thread_num=3

for ((i=0;i<${thread_num};i++));do # thread_num tokens
	echo
done >&1000

cd "$1"

for file in `find . -maxdepth 1 -type f -name '*.pcap' -o -name '*.cap' -o -name '*.pcapng'`
do
	read -u1000
	{
		echo "analyze $file"
		tshark -r $file -Y "dns.flags.response == 1" -T fields -e dns.qry.name -e dns.resp.name -e dns.a > $file-allDNSs.txt
		basic-tshark-joy-bro-tls.sh $file $file-allDNSs.txt
		echo >&1000 # release token
	}&	#backgroud process 
done

wait
exec 1000>&-
exec 1000<&-

echo "TLS flows extraction finished."
