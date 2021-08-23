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
ansible-playbook --vault-password-file ./vault_secret launch-workshop-workstation.yml
