#!/bin/bash
# you can run this as many times as you want
# it will only create one *workstation*.
# but if you selected to auto launch a workshop
# it will launch another *workshop* at the end of run.
#
# to disable this functionality,
# ./edit-groupvars.sh and change workshop.auto_launch to no
# before running again
#
#
# for debugging
#ansible-playbook -vvv --vault-password-file ./vault_secret launch-workshop-workstation.yml
aws_user=fedora
ansible-playbook --vault-password-file ./vault_secret \
    -e "aws_user=${aws_user}" \
    tasks/launch-workshop-workstation.yml
if [[ -e "workshop-details" ]]
then
  grep 'auto_launch: no' ./workshop-details > /dev/null && exit 0
  sshcmd=$(grep -- '-i key' ./workshop-details)
  workshop=$(grep -- 'name:' ./workshop-details)
  workshop="${workshop##name: }"
  ipaddy=$(grep -- 'ip:' ./workshop-details)
  ipaddy="${ipaddy##ip: }"
  if [[ ! -z "${sshcmd}" ]]
  then
    echo "CTRL-C WITHIN 5 SECS TO CANCEL. Running the provisioning command twice, first time to install the collections."
    sleep 5
    set -x
    ${sshcmd} "sudo systemctl start workshop.service"
    #${sshcmd} "cd workshops/provisioner/ ; ansible-playbook -e @workshop-${workshop}.yml provision_lab.yml" || \
    #${sshcmd} "cd workshops/provisioner/ ; ansible-playbook -e @workshop-${workshop}.yml provision_lab.yml"
    set +x
    echo "Visit https://${ipaddy}:9090/system/services#/workshop.service to watch the status. Log in with the user and default password you set, ie fedora/ansible123"
  fi
fi

