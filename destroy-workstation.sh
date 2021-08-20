#!/bin/bash
ansible-playbook --vault-password-file ./vault_secret destroy-workshop-workstation.yml
