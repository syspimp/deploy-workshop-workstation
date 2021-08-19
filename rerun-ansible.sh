#!/bin/bash
#ansible-playbook -vvv --vault-password-file ./vault_secret launch-workshop-workstation.yml
ansible-playbook --vault-password-file ./vault_secret launch-workshop-workstation.yml
