#!/bin/bash
if [[ ! $1 ]]
  then
  echo
  echo "This will clean/remove your workshop configuration."
  echo "You will need to tell me EXPLICITLY 'yes' to remove your workshop configuration."
  echo "Usage: $0 yes"
  echo "Example: $0 yes"
  echo
  echo
  exit 1;
fi
warning="${1}"
echo
echo "WARNING: This is will REMOVE any workshop configuration you have in the following files:"
echo -e "- ./vault_secret\n- group_vars/all\n- roles/deploy-workshop-workstation/files/manifest.zip\n- keys/key.ppk"
echo
echo "The manifest.zip will be deleted! I hope you have an unencrypted copy."
echo
echo "If you want to save those files, Ctrl-C now and run ./save-workshop.sh"
echo "Press enter to restore everything back to default"
echo
echo
read
if [[ "${warning}" == "yes" ]]
then
  rm -f ./vault_secret
  rm -f roles/deploy-workshop-workstation/files/manifest.zip
  rm -f keys/key.ppk
  cp -f ./group_vars-all.orig ./group_vars/all
  echo "Success! You may now run './setup.sh' to deploy a workshop."
  echo
else
  echo "You didn't tell me 'yes'"
  echo "Example: $0 yes"
  exit 1;
fi
exit 0
