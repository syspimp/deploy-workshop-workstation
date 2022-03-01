#!/bin/bash
ansible-playbook -i workstation-inventory --vault-password-file ./vault_secret tasks/backup-workstation-tower.yml
