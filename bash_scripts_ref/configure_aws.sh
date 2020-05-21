#! /bin/bash

printf "%s\n%s\nap-southeast-2\njson" "$1" "$2" | aws configure
printf "\n"

