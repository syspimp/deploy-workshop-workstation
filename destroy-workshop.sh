#!/bin/bash
# if the inventory file exists, try to delete the workshop from it, first
if [[ -e workshop-details ]]
then
  sshcmd=$(grep -- '-i key' ./workshop-details)
  workshop=$(grep -- 'name:' ./workshop-details)
  workshop="${workshop##name: }"
  if [[ ! -z "${sshcmd}" ]]
  then
    echo "CTRL-C WITHIN 5 SECS TO CANCEL. Running the teardown command."
    sleep 5
    set -x
    ${sshcmd} "cd workshops/provisioner/ ; ansible-playbook -e @workshop-${workshop}.yml teardown_lab.yml"
    set +x
  fi
  #ansible-playbook --vault-password-file ./vault_secret -i workstation-inventory -e "destroy_workshop=yes" tasks/destroy-workshop-workstation.yml
else
  echo "I can't find the workshop-details file for your workshop. Run ./rerun-ansible.sh to build one."
  exit 1
fi

