
# Introducion

Extract and save **TLS** traffic from pcap files, and extract meta information of TLS traffic, such as server IP address, server domain name (including all CNAMEs), certificate, packet sizes and time intervals, etc.


# How to use 

./tls_flows.sh path-of-pcap-files  
Note: you need to modify the **PATH**  environment variable corresponding to your system in the shell code

# Installation (tested in Ubuntu 18.04)

(1) Install the latest version of tshark  
sudo add-apt-repository ppa: wireshark-dev / stable  
sudo apt-get update  
sudo apt-get install tshark  
(2) Install bro  
sudo apt-get install bro  
sudo apt-get install bro-cut  
(3) Install Joy  
https://github.com/cisco/joy  
Note: when install joy, run ./configure without parameters, that is, compression is not enabled
