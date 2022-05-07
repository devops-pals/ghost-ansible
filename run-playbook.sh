#!/bin/bash

OLD_PWD=$(pwd)
cd $(dirname $0)

USER=${2:-root}

if ! command -v ansible-playbook &> /dev/null; then
    echo "You must first install ansible before running this command"
    echo "Make sure 'ansible-playbook' exists in your PATH"
    exit
fi

INVENTORY=""

if [ -z "$1" ]; then
    read -p "What inventory do you want to use?: " -r
    INVENTORY=$REPLY
else
    INVENTORY=$1
fi

echo
echo "==============================================================================="
echo "The playbook assumes that the DNS entry for your domain points to the instance."
echo "This is important to ensure the LetEncrypt certificate is generated correctly."
echo "==============================================================================="; echo

echo "     User: $USER"
echo "Inventory: inventories/$INVENTORY"
echo

read -p "Do you want to proceed? (y/N): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Goodbye."
    exit
fi

if [ "$USER" == "root" ]; then
    ansible-playbook -i inventories/$INVENTORY -u $USER playbooks/ghost.yaml
else
    ansible-playbook -i inventories/$INVENTORY -u $USER playbooks/ghost.yaml --ask-become-pass
fi

cd $OLD_PWD
