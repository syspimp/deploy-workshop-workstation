#!/bin/bash
vmtype=fedora
while getopts "dt:n:" OPTION
do
  case "$OPTION" in
    # debug
    d) set -x
      ;;
    t) vmtype=$OPTARG
      ;;
    n) vmname=$OPTARG
      ;;
    *) echo "Usage: $0 [-d] -t (rhel7|rhel8|fedora) -n 'name to tag vm'"
  esac
done
if [[ ! -z "$vmname" ]]
then
  ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory -e "aws_vmname=${vmname} aws_ostype=${vmtype}" tasks/launch-aws-vm.yml
else
  echo
  echo "Pass the name of the vm to start and edit tasks/launch-aws-vm.yml with your preferences. Run ./setup.sh first to build the base configuration."
  echo
  echo "Example:"
  echo './$0 -n "my_cool_vm"'
  exit 1
fi

