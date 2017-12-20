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
apt-get -y install git > /dev/null
echo Creating Vms:
echo
ID1="$(onetemplate instantiate "ubuntu-16.04VIRT" --name web --user $USER --password $PASS --endpoint $ENDPOINT  | cut -d " " -f 3)"
ID2="$(onetemplate instantiate "ubuntu-16.04" --name db  --user $USER --password $PASS --endpoint $ENDPOINT  | cut -d " " -f 3)"
ID3="$(onetemplate instantiate "debian9-lxde" --name client  --user $USER --password $PASS --endpoint $ENDPOINT | cut -d " " -f 3)"

echo
echo apt-get install ansible
apt-get -y install software-properties-common > /dev/null
apt-add-repository -y ppa:ansible/ansible > /dev/null
apt-get update > /dev/null
apt-get -y install ansible > /dev/null
echo Waiting for burgers
sleep 40
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
rm /etc/ansible/ansible.cfg
echo "[defaults]" > /etc/ansible/ansible.cfg
echo "host_key_checking = False" >> /etc/ansible/ansible.cfg
echo
cat /etc/ansible/hosts
echo
ansible all -m ping
echo
cd ansible
echo Playing db.yml
ansible-playbook db.yml
echo Playing web.yml
ansible-playbook web.yml
echo Playing client.yml
ansible-playbook client.yml
echo Done...Site should be up and running
echo
echo Desktop connection info
echo User: klientas
echo Password: topkek
echo
echo Website connection info
onevm show $ID1 --user $USER --password $PASS --endpoint $ENDPOINT | grep -wi "PRIVATE_IP"
exit

