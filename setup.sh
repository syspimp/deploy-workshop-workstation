#!/bin/bash
clear
function check_manifest {
  if [ ! -e "roles/deploy-workshop-workstation/files/manifest.zip" ]
  then
    echo
    echo "Ansible Automation Platform uses Satellite-style entitlements manifests"
    echo "You need to visit the url below to create a Satellite 6.8 manifest. Add Ansible Automation Platform subscriptions to it."
    echo
    echo "Download/export the manifest, name it manifest.zip and COPY it to ./roles/deploy-workshop-workstation/files/manifest.zip"
    echo "https://access.redhat.com/management/subscription_allocations"
    echo
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
    echo
    echo "Provide the workshop details."
    echo -e "Workshop types are:\n- windows,\n- rhel,\n- rhel_90 (rhel in 90 minutes),\n- security,"
    echo -e "- network,\n- f5,\n- smart_mgmt,\n- demo (installs all ansible demos but fails at the end)"
    echo "The defaults will be displayed in [brackets]. Hit enter to accept."
    echo "Press enter when ready"
    read
    read -p "Workshop Name [${USER}-workshop]: " wrkname
    if [[ -z "$wrkname" ]]
    then
      wrkname="${USER}-workshop"
    fi
    sed -i -e "s/name: demo-workshop/name: $wrkname/g" group_vars/all
    read -p "Workshop Type [windows]: " wrktype
    if [[ -z "$wrkype" ]]
    then
      wrktype="windows"
    fi
    sed -i -e "s/type: windows/type: $wrktype/g" group_vars/all
    read -p "Number of Students for this workshop [2]: " wrkstudents
    if [[ -z "$wrkstudents" ]]
    then
      wrkstudents="2"
    fi
    sed -i -e "s/number_of_students: 2/number_of_students: $wrkstudents/g" group_vars/all
    read -p "Required: AWS DNS Zone to use [none]: " wrkzone
    #if [[ -z "$wrkzone" ]]
    #then
    #  wrkzone="example.com"
    #fi
    sed -i -e "s/dns_zone: example.com/dns_zone: $wrkzone/g" group_vars/all
    read -p "Default Password for students [ansible123]: " wrkpass
    if [[ -z "$wrkpass" ]]
    then
      wrkpass="ansible123"
    fi
    sed -i -e "s/default_password: ansible123/default_password: $wrkpass/g" group_vars/all
    read -p "Do you want to autolaunch this workshop when tower is installed [yes]? (yes or no) " autolaunch
    if [[ -z "$autolaunch" ]]
    then
      autolaunch="yes"
    fi
    sed -i -e "s/auto_launch: yes/auto_launch: $autolaunch/g" group_vars/all
  fi
  echo "Step 2 Done!"
  echo
  return 0
}

function check_aws {
  grep 'keyid:' group_vars/all > /dev/null
  if [ $? -ne 1 ]
  then
    echo
    echo "If you don't have one, you will need to visit url below to create AWS access keys."
    echo "When you have the access key and secret, press enter."
    echo
    echo "https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials"
    read
    read -p "AWS Key ID: " aws_key
    read -p "AWS Secret Key: " aws_secret
    ESCAPED_REPLACE=$(printf '%s\n' "${aws_secret}" | sed -e 's/[\/&]/\\&/g')
    sed -i -e "s/^  keyid:/  keyid: $aws_key/g" group_vars/all
    sed -i -e "s/^  secret:/  secret: ${ESCAPED_REPLACE}/g" group_vars/all
  fi
  echo "Step 3 Done!"
  echo
  return 0
}

function check_redhat {
  grep 'svcuser:' group_vars/all > /dev/null
  if [ $? -ne 1 ]
  then
    echo
    echo "Enter your Redhat Customer Portal creds. Don't worry we will encrypt them. We will need to register the workstation."
    read -p "Redhat Customer Portal username: " cdnuser
    read -p "Redhat Customer Portal password: " cdnpass
    sed -i -e "s/notacdnuser/${cdnuser}/g" group_vars/all
    sed -i -e "s/notacdnpass/${cdnpass}/g" group_vars/all
    echo
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
    sed -i -e "s/12345|your-name-here/${svcuser}/g" group_vars/all
    sed -i -e "s/abcd.paste.long.block.of.text.here.svcpass.xyz/${svcpass}/g" group_vars/all
    sed -i -e "s/abcd.paste.long.block.of.text.here.token.xyz/${token}/g" group_vars/all
  fi
  echo "Step 4 Done!"
  echo
  return 0
}

function encrypt_files {
  echo
  echo "I will now encrypt your sensitive info in group_vars/all." 
  ansible-vault encrypt --vault-password-file ./vault_secret group_vars/all
  echo "If you need to edit in the future, use the command: "
  echo "ansible-vault edit --vault-password-file ./vault_secret group_vars/all"
  echo "Step 5 Done!"
  echo
  return 0
}

function helper {
  if [ -e "./group_vars-all.orig" ]
  then
    echo
    echo "You are rerunning the setup.sh script. If you want to run the ansible playbook "
    echo "without changing the workshop setup or your credentials, then run "
    echo "'./rerun-ansible.sh'"
    echo "You only need to run setup.sh to setup your credentials."
    echo 
    echo "If you want to edit your credentials or workshop setup in the group_vars/all file, then run"
    echo "'./edit-groupvars.sh'"
    echo
    echo "To continue, I need to restore the group_vars/all back to the original "
    echo "and if the manifest has been encrypted, you should use the same vault password."
    echo
    echo "If you don't want this, Ctrl-C now. Otherwise, press enter to continue"
    read
    cp -f group_vars-all.orig group_vars/all
  else
    cp group_vars/all group_vars-all.orig
  fi
  echo
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
  echo "1. Create manifest.zip file containing Ansible Automation Platform subscriptions and place it in roles/deploy-workshop-workstation/files/manifest.zip"
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
check_workshop
check_manifest
while [[ "$?" -ne 0 ]]
do
  check_manifest
done
check_aws
check_redhat
encrypt_files
echo "Step 6: Ready to deploy! Press enter to launch and configure your Workstation."
read
echo "Installing ansible collections ..."
ansible-galaxy install -r ./requirements.yml
echo "Executing: ansible-playbook --vault-password-file ./vault_secret launch-workshop-workstation.yml"
ansible-playbook --vault-password-file ./vault_secret launch-workshop-workstation.yml
if [[ $? -ne 0 ]]
then
  echo "There is only one known bug, t3.large is not available in us-east-1c,"
  echo "and sometimes aws puts the network bits in there, so the instance tries to launch in us-east-1c and fails"
  echo
  echo "The only known fix is to try again. Run:"
  echo "./destroy.sh && ./rerun-ansible.sh"
  echo
  echo "If you need to edit your configuration, run:"
  echo "./edit-groupvars.sh"
else
  echo "Success! A workshop is being built for you at the URL in the ansible output above."
  echo "When you are finished with the workshop, delete everything by running:"
  echo "./destroy.sh"
  echo "You can redeploy the workshop again by running"
  echo "./rerun-ansible.sh"
  echo "Have fun!"
fi
