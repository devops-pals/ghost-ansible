#!/bin/bash

OLD_PWD=$(pwd)
cd $(dirname $0)

if ! command -v ansible-playbook &> /dev/null; then
    echo "You must first install ansible before running this command."
    echo "Make sure 'ansible-playbook' exists in your PATH."
    exit 1
fi

USER=${2:-root}
INVENTORY=""

if [ -z "$1" ]; then
    read -p "What inventory do you want to use?: " -r
    INVENTORY=$REPLY
else
    INVENTORY=$1
fi

echo
echo "==============================================================================="
echo "If using TLS, ensure the DNS entry for your domain points to your host."
echo "This is important to ensure the LetEncrypt certificate is generated correctly."
echo "==============================================================================="
echo

echo "     User: $USER"
echo "Inventory: inventories/$INVENTORY"
echo

read -p "Do you want to proceed? (y/N): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Goodbye."
    exit 0
fi

if [ "$USER" == "root" ]; then
    ansible-playbook -i inventories/$INVENTORY -u $USER playbooks/ghost.yaml
else
    ansible-playbook -i inventories/$INVENTORY -u $USER playbooks/ghost.yaml --ask-become-pass
fi

echo "Done."

cd $OLD_PWD
