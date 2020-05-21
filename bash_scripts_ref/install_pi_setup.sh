#! /bin/bash

if [[ $EUID == 0 ]]; then
   printf "This script must be run as non root, without sudo !!!\n"
   printf "command to run './install_pi_setup.sh'\n"                       
   exit 1
fi

user=$(whoami)

if [[ $user != "<user>" ]]; then
        printf "current <user> is %s\n" $user
        printf "Sorry, scripts can be run only by '<user>' user\n"
        printf "Please login as '<user>' user, command 'sudo su <user>'\n"
        exit 0
fi

input=100
while [[ $input != "exit" && $input != 0 && $input != "no" ]]
do
        printf "\n######### Run the scripts in order #########\n"
        printf "\t 1. Delete pi <user> \n"
	printf "\t 2. Update & Upgrade packages (optional, only if not already done)\n"
        printf "\t 3. Install mercury package dependencies\n"
        printf "\t 4. Create ssh keys for <user> user\n"
        printf "\t 5. Upload ssh keys to cloud (optional, '<key>' & '<key>.pub' can be manually copied from ~/.ssh/)\n"
        printf "\t 6. Install mercury services\n"
	printf "\t 7. Delete private and public ssh keys (** only after step 5. or manually copying ssh keys)\n"
	printf "\t 8. Uninstall awscli and credentials (optional, only if step 5. was run before)\n"
        printf "\t 0. To exit \n"

        read input

        if [[ $input == 1 ]]; then
                user_exists=$(sudo cut -d: -f1 /etc/passwd | grep "pi")
                if [[ ! -z $user_exists ]]; then
                        sudo userdel -f pi || true
                        sudo rm -rf /home/pi || true
                        wait
                        printf "pi user deleted\n"
                else
                        print "pi user does not exist\n"
                fi
        elif [[ $input == 2 ]]; then
        	sudo apt-get --assume-yes update
		wait
		sudo apt-get --assume-yes upgrade 
                wait
		printf "### Reboot required after upgrade ###\n"
		printf "### enter 'y' to reboot now ###\n"
		read input
		if [[ $input == "y" || $input == "Y" ]]; then
			printf ".......rebooting now.......\n"
			sudo reboot now
		fi
        elif [[ $input == 3 ]]; then
                sudo ./scripts/install_packages.sh
                wait
        elif [[ $input == 4 ]]; then
                sudo -u <key> ./scripts/generate_sshkey.sh
                wait
		printf "\n-----WARNING-----\n"
		printf "run 'step 5' to upload ssh private key to cloud, alternatively it can be copied from '~/.ssh/<key>'\n\n"
        elif [[ $input == 5 ]]; then
                printf "enter aws access key\n"
                read access_key
                printf "enter aws secret key\n"
                read private_key
                sudo ./scripts/install_aws_cli.sh
                wait
		sudo ./scripts/configure_aws.sh $access_key $private_key
		wait
		check_credentials=$(sudo aws sts get-caller-identity)

		if [[ $check_credentials != "Unable to locate credentials"* ]]; then
		        printf "configured awscli with credentials\n"
			sudo aws s3 cp ~/.ssh/<key> s3://mercury-project/ 
			sudo aws s3 cp ~/.ssh/<key>.pub s3://mercury-project/ 
			printf "uploaded ssh private key to s3://mercury-project\n"
		else
			printf "something went wriong, your crendentials did not work, try again\n"
		fi
        elif [[ $input == 6 ]]; then
                sudo ./mercury_setup_*.sh
                wait
        elif [[ $input == 7 ]]; then
                sudo rm ~/.ssh/<key>
		sudo rm ~/.ssh/<key>.pub
		printf "deleted ssh private and public keys\n"
                wait
        elif [[ $input == 8 ]]; then
       		sudo dpkg -r --force-all awscli
		sudo rm -rf ~/.aws
		sudo rm -rf /usr/local/aws
		sudo rm /usr/local/bin/aws
		sudo /usr/bin/yes | sudo python3 -m pip uninstall boto3 botocore 
		printf "uninstalled awscli and deleted credentials\n"
                wait
        fi
done

