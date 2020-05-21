#!/bin/bash


# determine the line number of this script where the payload begins
PAYLOAD_LINE=`awk '/^__PAYLOAD_BELOW__/ {print NR + 1; exit 0; }' $0`

# use the tail command and the line number we just determined to skip
# past this leading script code and pipe the payload to tar

printf "#### setup cron job to turn wifi-on & sync sysclock with hwclock ####\n"
cron_job="@reboot /home/<user>/mercury/cron_startup_script.sh >/dev/null 2>&1"
cron_job_exists=$(sudo crontab -l | grep -q "$cron_job" && echo true || echo false)

if [[ $cron_job_exists == *"no crontab"* || $cron_job_exists == false ]];then
        (sudo crontab -l 2>/dev/null; echo $cron_job) | crontab -
fi

input=100
printf "#### set time for pi ####\n"
printf "enter 'y' to set time or 'n' to continue, (y/n)\n"
read input

if [[ $input == "y" || $input == "Y" ]]
then
	sudo timedatectl set-timezone Australia/Perth
	printf "\ttimezone set to Australia/Perth\n"
	printf "\tenter date in yyyy-mm-dd format eg. 2019-05-22\n"
	read date
	sudo date +%Y-%m-%d -s $date
	printf "\tenter time in 24 hour format hh:mm:ss eg. 15:20:30\n"
	read time
	sudo date +%T -s $time
fi

printf "#### disable bluetooth ####\n"
sudo rfkill block bluetooth

printf "#### Installing setup configuration for pi ####\n"
if [[ -d /pi_setup ]]
then
	sudo rm -rf /pi_setup
fi

printf "### create an install folder /pi_setup\n"
mkdir /pi_setup

printf "### copy setup files to /pi_setup\n"
tail -n+$PAYLOAD_LINE $0 | tar xzv -C /pi_setup/
cd /pi_setup
wait

printf "### create <user> user and add to root\n"
user_exists=$(cut -d: -f1 /etc/passwd | grep '<user>')

if [[ -z $user_exists ]] 
then
	useradd -m -p $(openssl passwd -1 ${1:""}) -s /bin/bash -g sudo <user>
	usermod -a -G audio <user>
else
	printf "<user> user already exists\n"
fi

printf "#### Completed! ####\n"
printf "Login as <user> user and run the install script\n"
printf "\tcd /pi_setup\n"
printf "\tsudo su <user>\n"
printf "\t./install_pi_setup.sh\n"

exit 0

# the 'exit 0' immediately above prevents this line from being executed
__PAYLOAD_BELOW__
