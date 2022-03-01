#!/bin/bash
# if the inventory file exists, try to delete the workshop from it, first
if [[ -e workshop-details ]]
then
  sshcmd=$(grep -- '-i key' ./workshop-details)
  workshopname=$(grep 'name:' ./workshop-details| sed -e 's/name: //g')
  if [[ ! -z "${sshcmd}" ]]
  then
    echo "CTRL-C WITHIN 5 SECS TO CANCEL. Running the teardown command."
    sleep 5
    set -x
    timeout 10 ${sshcmd} "cd workshops/provisioner/ ; ansible-playbook -e @workshop-${workshopname}.yml teardown_lab.yml"
    set +x
  fi
  #ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory -e "destroy_workshop=yes" tasks/destroy-workshop-workstation.yml
fi
# remove the workstation
ansible-playbook --vault-password-file ./vault_secret -e "destroy_workstation=yes" tasks/destroy-workshop-workstation.yml

