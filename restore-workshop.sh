#!/bin/bash
if [[ ! $1 ]]
  then
  echo
  echo "This will restore your workshop from saved/"
  echo "Please provide the path to file of the workshop to restore."
  echo "Usage: $0 <path_to_workshop_backup>"
  echo "Example: $0 saved/company_xyz-workshop.tgz"
  echo
  echo
  exit 1;
fi
backup="${1}"
echo
echo "WARNING: This is will overwrite any workshop configuration you have in the following files:"
echo -e "- ./vault_secret\n- group_vars/all\n- roles/deploy-workshop-workstation/files/manifest.zip\n"
echo "If you want to save those files, Ctrl-C now and run ./save-workshop.sh"
echo "Press enter to contine"
echo
echo
read
if [[ -e "${backup}" ]]
  then
    tar -zxvf ${backup}
    echo "Success! You may now run './rerun-ansible' to deploy your workshop."
    echo
  else
    echo "File ${backup} does NOT exist! Correct the path and try again."
    exit 1;
fi
exit 0
