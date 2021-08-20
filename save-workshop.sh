#!/bin/bash
if [[ ! $1 ]]
  then
  echo
  echo "This will backup your workshop to saved/"
  echo "Please provide a name for this workshop (no spaces)"
  echo "Usage: $0 <name_of_workshop>"
  echo "Example: $0 company_xyz"
  echo
  echo
  exit 1;
fi
name="${1}-workshop"
if [[ ! -e "saved/${name}.tgz" ]]
  then
    tar -cvzf saved/${name}.tgz ./vault_secret group_vars/all roles/deploy-workshop-workstation/files/manifest.zip
    echo "Workshop backup location: saved/${name}.tgz"
  else
    echo "File saved/${name}.tgz already exists! Choose a different name or remove the backup."
    exit 1;
fi
exit 0
