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

cd "$1"

for file in `find . -maxdepth 1 -type f -name '*.pcap' -o -name '*.cap' -o -name '*.pcapng'`
do
	echo "analyze $file"
	tshark -r $file -Y "dns.flags.response == 1" -T fields -e dns.qry.name -e dns.resp.name -e dns.a > $file-allDNSs.txt
	basic-tshark-joy-bro-tls.sh $file $file-allDNSs.txt
done

echo "TLS flows extraction finished."
