#!/bin/bash

#docker_directory="/srv/docker"
docker_directory="/tmp/script_scratch"
perforce_directory="${docker_directory}/perforce-helix-core"

echo "Preparing ${perforce_directory}..."

as_sudo=''
if [ 0 -ne $EUID ]; then
    as_sudo='sudo'
fi

if [ -d "$perforce_directory" ]; then
    echo "Error: ${perforce_directory} already exists."
    exit
fi

$as_sudo mkdir -v -p "${perforce_directory}"
if [ 0 -ne $? ]; then
    echo "Error creating directory."
    exit
fi

$as_sudo mkdir -v "${perforce_directory}/dbs"
if [ 0 -ne $? ]; then
    echo "Error creating directory"
    exit
fi

$as_sudo mkdir -v "${perforce_directory}/p4dctl.conf.d"
if [ 0 -ne $? ]; then
    echo "Error creating directory"
    exit
fi

$as_sudo mkdir -v "${perforce_directory}/perforce-data"
if [ 0 -ne $? ]; then
    echo "Error creating directory"
    exit
fi

echo "Copying docker files..."

$as_sudo cp -v "./compose.yaml" "${docker_directory}/"
if [ 0 -ne $? ]; then
    echo "Error copying file."
    exit
fi

$as_sudo cp -v "./perforce-helix-core" "${perforce_directory}/"
if [ 0 -ne $? ]; then
    echo "Error copying file."
    exit
fi

echo "Copying Perforce config files..."

$as_sudo cp -v "./p4dctl-config/"* "${perforce_directory}/p4dctl.conf.d/"
if [ 0 -ne $? ]; then
    echo "Error copying file."
    exit
fi


cd "${docker_directory}"
#$as_sudo docker compose up -d
#if [ 0 -ne $? ]; then
#    echo "Error starting docker."
#    exit
#fi

echo ""
echo "Running the Perforce Helix setup script. Use these parameters when prompted:"
echo "- Server name: master"
echo "- Server root: /perforce-data"
echo "- Server port: 1666"
echo "- Enter a very strong password for the super user"
echo ""
$as_sudo docker compose run --rm perforce /opt/perforce/sbin/configure-helix-p4d.sh

echo ""
echo "Success! Run \"sudo docker compose up -d\" when you're ready to start the service!"
echo ""

exit
