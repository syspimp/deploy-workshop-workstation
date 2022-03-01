#!/bin/bash
ansible-playbook --vault-password-file ./vault_secret tasks/start-aws-vms.yml
