#!/bin/bash
ansible-playbook --vault-password-file ./vault_secret tasks/stop-aws-vms.yml
