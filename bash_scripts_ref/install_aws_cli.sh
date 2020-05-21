#! /bin/bash

sudo apt-get --assume-yes install curl

aws_installer_path=~/aws_installer

printf "### install aws cli\n"
if [[ -d $aws_installer_path ]]
then
	rm -rf $aws_installer_path
fi

mkdir "$aws_installer_path"
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "$aws_installer_path/awscli-bundle.zip"
cd $aws_installer_path
unzip awscli-bundle.zip
sudo /usr/bin/python3 awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
wait

printf "### install aws python sdk packages\n"
boto3_exists=$(python3 -c 'import pkgutil; print(1 if pkgutil.find_loader("boto3") else 0)')
botocore_exists=$(python3 -c 'import pkgutil; print(1 if pkgutil.find_loader("botocore") else 0)')

if [[ boto3_exists == 0 || botocore_exists == 0 ]]
then
	/usr/bin/yes | python3 -m pip install boto3 botocore
else
	/usr/bin/yes | python3 -m pip install  boto3 botocore --upgrade
fi

printf "completed awscli installation!"
