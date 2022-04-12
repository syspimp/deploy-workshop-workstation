#!/bin/bash
while getopts "dn:" OPTION
do
  case "$OPTION" in
    # debug
    d) set -x
      ;;
    n) vmname=$OPTARG
      ;;
    *) echo "Usage: $0 -n 'name of vm to manage'"; exit 1
      ;;
  esac
done
if [[ ! -z "$vmname" ]]
then
  ansible-playbook --vault-password-file ./vault_secret -i aws-inventory -e "aws_vmname=${vmname}" tasks/push-tower-to-vm.yml
else
  echo
  echo "Pass the name of the vm to configure tower on."
  echo
  echo "Example:"
  echo './$0 -n "my_cool_vm"'
  exit 1
fi

