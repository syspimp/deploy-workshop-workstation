#!/bin/bash
vmtype=fedora
while getopts "do:n:" OPTION
do
  case "$OPTION" in
    # debug
    d) set -x
      ;;
    o) ostype=$OPTARG
      ;;
    n) vmname=$OPTARG
      ;;
    *) echo "Usage: $0 [-d] -o (rhel7|rhel8|fedora) -n 'name to tag vm'" ; exit 1
      ;;
  esac
done
if [[ ! -z "$vmname" ]]
then
  case "$ostype" in
    rhel*) aws_user=ec2-user
      ;;
    fedora) aws_user=fedora
      ;;
  esac
  ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory \
    -e "aws_vmname=${vmname} aws_ostype=${ostype} aws_user=${aws_user}" \
    tasks/launch-aws-vm.yml
else
  echo
  echo "Pass the name of the vm to start and edit tasks/launch-aws-vm.yml with your preferences. Run ./setup.sh first to build the base configuration."
  echo
  echo "Example:"
  echo './$0 -n "my_cool_vm" -o rhel8'
  exit 1
fi

