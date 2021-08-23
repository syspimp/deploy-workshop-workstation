#!/bin/bash
# if the inventory file exists, try to delete the workshop from it, first
if [[ -e workstation-inventory ]]
then
  #ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory -e tasks/destroy-workshop-workstation.yml
  ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory -e "destroy_workshop=yes" tasks/destroy-workshop-workstation.yml
else
  echo "I can't find the inventory file for your workshop. Run ./rerun-ansible.sh to build one."
  exit 1
fi

