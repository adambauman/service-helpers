#!/bin/bash

set -e

as_sudo=''
if [ 0 -ne $EUID ]; then
as_sudo='sudo'
fi

echo "Starting docker install..."

# Add Docker's official GPG key:
$as_sudo apt-get update
$as_sudo apt-get install ca-certificates curl gnupg --yes
$as_sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $as_sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$as_sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  $as_sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$as_sudo apt-get update --yes

$as_sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --yes

echo ""
echo "Success!"
echo ""
