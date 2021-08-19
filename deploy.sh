#!/bin/bash
clear
function check_manifest {
  if [ ! -e "roles/deploy-workshop-workstation/files/manifest.zip" ]
  then
    echo "Ansible Automation Platform uses Satellite-style entitlements manifests"
    echo "You need to visit the url below to create a Satellite 6.8 manifest. Add Ansible Automation Platform subscriptions to it."
    echo "Download/export the manifest, name it manifest.zip and place it in ./roles/deploy-workshop-workstation/files/manifest.zip"
    echo "https://access.redhat.com/management/subscription_allocations"
    echo "Press enter when this is complete. I'll check again. Or Ctrl-C and start again when ready."
    read
    return 1
  fi
  echo "I will now encrypt the manifest."
  ansible-vault encrypt --vault-password-file ./vault_secret roles/deploy-workshop-workstation/files/manifest.zip
  echo "Step 1 Done!"
  echo
  return 0
}

function check_workshop {
  grep 'workshop:' group_vars/all > /dev/null
  if [ $? -ne 1 ]
  then
    if [[ -e 'group_vars-all.orig' ]]
    then
      echo "You are rerunning the script. I need to restore the group_vars/all back to the original"
      echo "If you don't want this, Ctrl-C now. Otherwise, press enter to continue"
      read
      cp -f group_vars-all.orig group_vars/all
    else
      cp group_vars/all group_vars-all.orig
    fi
    echo "Give the workshop details."
    echo "Workshop types are windows,rhel,security,etc"
    echo "Press enter when ready"
    read
    read -p "Workshop Name: " wrkname
    sed -i -e "s/name: demo-workshop/name: $wrkname/g"	group_vars/all
    read -p "Workshop Type: " wrktype
    sed -i -e "s/type: windows/type: $wrktype/g"	group_vars/all
    read -p "Number of Students for this workshop: " wrkstudents
    sed -i -e "s/number_of_students: 2/number_of_students: $wrkstudents/g"	group_vars/all
    read -p "DNS Zone to use: " wrkzone
    sed -i -e "s/dns_zone: example.com/dns_zone: $wrkzone/g"	group_vars/all
    read -p "Default Password for students: " wrkpass
    sed -i -e "s/default_password: ansible123/default_password: $wrkpass/g"	group_vars/all
  fi
  echo "Step 2 Done!"
  echo
  return 0
}

function check_aws {
  grep 'keyid:' group_vars/all > /dev/null
  if [ $? -ne 1 ]
  then
    echo "If you don't have one, you will need to visit url below to create AWS access keys."
    echo "When you have the access key and secret, press enter."
    echo
    echo "https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials"
    read
    read -p "AWS Key ID: " aws_key
    read -p "AWS Secret Key: " aws_secret
    sed -i -e "s/^  keyid:/  keyid:  $aws_key/g"	group_vars/all
    sed -i -e "s/^  secret:/  secret:  $aws_secret/g"	group_vars/all
  fi
  echo "Step 3 Done!"
  echo
  return 0
}

function check_redhat {
  grep 'svcuser:' group_vars/all > /dev/null
  if [ $? -ne 1 ]
  then
    echo "Redhat Service Accounts are a way to access the redhat api without using your customer portal credentials."
    echo
    echo "Step 1 of 2: Visit https://access.redhat.com/terms-based-registry/#/accounts to create a service account/password"
    echo "When you have the svc account/password, press enter."
    read
    read -p "Redhat Service Account User (looks like: 12345|your-name-here): " svcuser
    read -p "Redhat Service Accout Password: " svcpass
    echo "Step 2 of 2: You will also need to generate an offline token by visiting the url below"
    echo
    echo "https://access.redhat.com/management/api"
    echo "When you have generated the offline token, press enter."
    read
    read -p "Redhat Offline Token: " token
    sed -i -e "s/12345|your-name-here/$svcuser/g"	group_vars/all
    sed -i -e "s/abcd.paste.long.block.of.text.here.svcpass.xyz/$svcpass/g"	group_vars/all
    sed -i -e "s/abcd.paste.long.block.of.text.here.token.xyz/$token/g"	group_vars/all
  fi
  echo "Step 4 Done!"
  echo
  return 0
}

function encrypt_files {
  echo "I will now encrypt your sensitive info in group_vars/all." 
  ansible-vault encrypt --vault-password-file ./vault_secret group_vars/all
  echo "If you need to edit in the future, use the command: "
  echo "ansible-vault --vault-password-file ./vault_secret edit group_vars/all"
  echo "Step 5 Done!"
  echo
  return 0
}

function helper {
  echo "I am the helper program. I will guide you to get everything setup and deployed."
  echo
  echo "The ansible playbooks in this repo will:"
  echo "- create vpc, subnet, gateway, security group, and a workstation vm"
  echo "- clone the ansible/workshops repo and configure it per your settings"
  echo "- install the latest Ansible Automation Platform on the workstation"
  echo "- configure AAP with job templates, credentials, inventory, and surveys"
  echo "  to deploy workshops at the click of a button"
  echo
  echo "WORKSHOP DEPENDENCY: You will need a domain name configured in your AWS Route53 for the workshop deployment to succeed. You can still install just the workstation."
  echo 
  echo "There are six steps. It shouldn't take you more than 5 mins:"
  echo "1. Create manifest.zip file containing Ansible Automation Platform subscriptions and place it in ./files/"
  echo "2. Collect your workshop details"
  echo "3. Collect AWS credentials"
  echo "4. Collect Redhat service account credentials"
  echo "5. Encrypt your sensitive information"
  echo "6. Deploy the workstation!"
  echo
  echo "WARNING: This will modify your group_vars/all file."
  echo "Ready? Press enter to continue."
  read
  echo
  echo "Please type a password to use to vault encrypt your sensitive information."
  echo "Do NOT use a password you use for anything else."
  read -p "Vault Password: " vault_pass
  echo -e "#!/bin/bash\necho $vault_pass" > ./vault_secret
  chmod 0700 ./vault_secret
  echo "Thanks! Saved in ./vault_secret."
  echo
  return 0
}

helper
check_manifest
while [[ "$?" -ne 0 ]]
do
  check_manifest
done
check_workshop
check_aws
check_redhat
encrypt_files
echo "Step 6: Ready to deploy! Press enter to launch and configure your Workstation."
read
echo "Installing ansible collections ..."
ansible-galaxy install -r ./requirements.yml
ansible-playbook --vault-password-file ./vault_secret launch-workshop-workstation.yml
