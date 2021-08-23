#!/bin/bash
ansible-playbook -i workstation-inventory --vault-password-file ./vault_secret backup-workstation-tower.yml
