#!/bin/bash

echo "JH Start"
USER=toba3743
PASS=Nusibodo123
ENDPOINT=https://grid5.mif.vu.lt/cloud3/RPC2
echo apt-get update
apt-get update > /dev/null
echo
echo apt-get install opennebula-tools
apt-get -y install opennebula-tools > /dev/null
apt-get -y install git
echo Creating Vms:
echo
ID1="$(onetemplate instantiate "ubuntu-16.04VIRT" --name web --user $USER --password $PASS --endpoint $ENDPOINT  | cut -d " " -f 3)"
ID2="$(onetemplate instantiate "ubuntu-16.04" --name db  --user $USER --password $PASS --endpoint $ENDPOINT  | cut -d " " -f 3)"
ID3="$(onetemplate instantiate "ubuntu-16.04" --name client  --user $USER --password $PASS --endpoint $ENDPOINT | cut -d " " -f 3)"


echo
echo apt-get install ansible
apt-get -y install software-properties-common > /dev/null
apt-add-repository -y ppa:ansible/ansible > /dev/null
apt-get update > /dev/null
apt-get -y install ansible > /dev/null
sleep 20
echo
onevm show $ID1 --user $USER --password $PASS --endpoint $ENDPOINT
echo [web] > //etc/ansible/hosts
echo "$(onevm show $ID1 --user $USER --password $PASS --endpoint $ENDPOINT | grep -wi "PRIVATE_IP"|cut -d "\"" -f 2)" >> //etc/ansible/hosts
echo [db] >> //etc/ansible/hosts
echo "$(onevm show $ID2 --user $USER --password $PASS --endpoint $ENDPOINT | grep -wi "PRIVATE_IP"|cut -d "\"" -f 2)" >> //etc/ansible/hosts
echo [client] >> //etc/ansible/hosts
echo "$(onevm show $ID3 --user $USER --password $PASS --endpoint $ENDPOINT | grep -wi "PRIVATE_IP"|cut -d "\"" -f 2)" >> //etc/ansible/hosts
cat -n /etc/ansible/hosts |sed '2!d' | awk '{print $2}' | cat > /etc/ansible/web.txt
cat -n /etc/ansible/hosts |sed '4!d' | awk '{print $2}' | cat > /etc/ansible/mysql.txt
echo
git clone https://github.com/RokasAlechnavicius/virtualwebaskopija.git
git clone https://github.com/RokasAlechnavicius/ansible.git
echo
cat /etc/ansible/hosts
echo

