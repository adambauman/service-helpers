#!/bin/bash

docker_directory="/srv/docker"
perforce_directory="${docker_directory}/perforce-helix-core"

echo "Preparing ${perforce_directory}..."

as_sudo=''
if [ 0 -ne $EUID ]; then
    as_sudo='sudo'
fi

if [ -d "$docker_directory" ]; then
    echo "Error: ${docker_directory} already exists, this installation would clobber your docker compose, etc."
    exit
fi

set -e

$as_sudo mkdir -v -p "${perforce_directory}"
$as_sudo mkdir -v "${perforce_directory}/dbs"
$as_sudo mkdir -v "${perforce_directory}/p4dctl.conf.d"
$as_sudo mkdir -v "${perforce_directory}/perforce-data"

echo "Copying docker files..."

$as_sudo cp -v "./compose.yaml" "${docker_directory}/"
$as_sudo cp -v "./perforce-helix-core" "${perforce_directory}/"

echo "Copying Perforce config files..."

$as_sudo cp -v "./p4dctl-config/"* "${perforce_directory}/p4dctl.conf.d/"

echo ""
echo "Running the Perforce Helix setup script. Use these parameters when prompted:"
echo "- Server name: master"
echo "- Server root: /perforce-data"
echo "- Server port: 1666"
echo "- Enter a very strong password for the super user"
echo ""
$as_sudo docker compose -f "${docker_directory}/compose.yaml" run --rm perforce /opt/perforce/sbin/configure-helix-p4d.sh

echo ""
echo "Success! When you're ready to start the service:"
echo "sudo docker compose -f ${docker_directory}/compose.yaml up -d"
echo ""

exit
