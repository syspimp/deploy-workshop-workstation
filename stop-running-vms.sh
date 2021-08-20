#!/bin/bash
ansible-playbook --vault-password-file ./vault_secret stop-aws-vms.yml
