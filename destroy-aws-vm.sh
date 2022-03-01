#!/bin/bash
# takes vm name as as argument
if [[ $1 ]]
then
  vmname=$1
fi
if [[ ! -z "$vmname" ]]
then
  ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory -e "aws_vmname=${vmname} destroy_awsvm=yes" tasks/destroy-aws-vm.yml
else
  echo
  echo "Pass the name of the vm to terminate."
  echo
  echo "Example:"
  echo './$0 "my_cool_vm"'
  exit 1
fi

