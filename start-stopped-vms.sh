#!/bin/bash
ansible-playbook --vault-password-file ./vault_secret start-aws-vms.yml
