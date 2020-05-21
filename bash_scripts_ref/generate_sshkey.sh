#! /bin/bash

printf "### generate ssh keys\n"

ssh_path=~/.ssh
private_key="$ssh_path/<key>"
public_key="$ssh_path/<key>.pub"

if [[ ! -d $ssh_path ]]
then
	mkdir $ssh_path	
fi

if [[ -f $private_key ]]
then
	rm "$private_key"
fi

if [[ -f $public_key ]]
then
	rm "$public_key"
fi

printf "### replace sshd_config with new file with required settings\n"
sudo cp -f scripts/sshd_config /etc/ssh/sshd_config

cd ~
chown <user> .ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/<key> -P ""
printf "ssh key generated\n"
wait

printf "### give permission to login through ssh private key\n"
chmod 700 ~/.ssh
chown <user> ~/.ssh -R

if [[ -f $private_key ]]
then
	sudo cp $public_key "$ssh_path/authorized_keys"
else
	printf "Error!, $public_key does not exist"
fi
sudo service ssh restart

