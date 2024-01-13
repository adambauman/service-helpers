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

echo ""
echo "Success!"
