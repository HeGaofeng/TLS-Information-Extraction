# TLS-Traffic-Analysis
功能：从pcap文件中提取、保存TLS流量，并分析TLS流量的元信息，如IP地址、域名、证书、报文长度和时间间隔等。  
使用: ./tls_flows.sh path-of-pcap-files  
安装（Ubuntu操作系统）：  
（1）安装最新版tshark  
sudo add-apt-repository ppa:wireshark-dev/stable  
sudo apt-get update  
（2）安装bro  
sudo apt install bro  
（3）安装Joy  
https://github.com/cisco/joy  
编译时直接./configure，不带参数，即不启用压缩
