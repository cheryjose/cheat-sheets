#! /bin/bash

os_name=$(lsb_release -d)
if [[ $os_name == *"Raspbian"* ]];then
	printf "### enable filesystem journalling\n"
	sudo tune2fs -O has_journal -o journal_data /dev/mmcblk0p2	
fi

printf "### create folder\n"
mkdir -p /home/<user>/<folder>
wait

services=("<service1>.service" "<service2>.service" \
	"<service3>.service" "<service4>.service")

config_files=("src/data/<config1>.json" "src/data/<config2>.json" \
	"src/data/<config3>.json" "src/data/<config4>.json")

printf "### copy files\n"
sudo cp -rf src/data/media/* /home/<user>/<folder>/media/
sudo cp "file1.sh" "file2.sh" /home/<user>/<folder>
wait

# using a loop 
for config_file in ${config_files[*]};
do
  sudo cp $config_file /home/<user>/<folder>/config
done
wait


printf "### give permissions \n"
sudo chmod -R a+r /home/<user>/<folder1>
sudo chmod -R a+w /home/<user>/<folder2>
sudo chmod -R a+xr /home/<user>/<folder3>
sudo chmod -R a+r /home/<user>/<folder4>


# run a bash file 
sudo ./set_systemtype.sh
wait

printf "### install app and dependencies packages\n"
sudo python3 -m pip install -r requirements.txt
wait
sudo python3 setup.py install
wait

printf "### uninstall services if exists\n"
uninstall_services() {
if $(sudo systemctl list-units --full -all | grep -Fq $1);then
     sudo systemctl stop $1
     sudo systemctl disable $1
     sudo rm /etc/systemd/system/$1
     sudo systemctl daemon-reload
     sudo systemctl reset-failed     
fi
}

for service in ${services[*]};
do
  uninstall_services $service
done
wait

printf "### copy service configuration files and give permissions\n"
copy_service() {
sudo cp $1 /etc/systemd/system/$2
}

assign_permission_to_service() {
sudo chmod +x /etc/systemd/system/$1
}

for service in ${services[*]};
do
  copy_service "systemd_services/${service}" $service
  assign_permission_to_service $service
done
wait

printf "### start services\n"
start_service() {
sudo systemctl enable $service
sudo systemctl start $service
}

sudo systemctl daemon-reload
wait

for service in ${services[*]};
do
  start_service $service  
done
wait

printf "#### setup cron job to enable/disable services based on systemtype ####\n"
cron_job="@reboot /home/<user>/<folder>/cron_enable_services.sh >/dev/null 2>&1"
cron_job_exists=$(sudo crontab -l | grep -q "$cron_job" && echo true || echo false)

if [[ $cron_job_exists == *"no crontab"* || $cron_job_exists == false ]];then
        (sudo crontab -l 2>/dev/null; echo $cron_job) | crontab -
fi
wait

printf "#### Completed! ####\n"
