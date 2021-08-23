#!/bin/bash
# if the inventory file exists, try to delete the workshop from it, first
if [[ -e workstation-inventory ]]
then
  #ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory -e destroy-workshop-workstation.yml
  ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory -e "destroy_workshop=yes" destroy-workshop-workstation.yml
fi
# remove the workstation
ansible-playbook --vault-password-file ./vault_secret -e "destroy_workstation=yes" destroy-workshop-workstation.yml

