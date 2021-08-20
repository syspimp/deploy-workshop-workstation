# What

This will **deploy a workstation ready to deploy workshops via cli or ansible tower** in your aws account. It will setup a vpc, subnet, ssh keys, dns records, launch a new workstation running the latest Ansible Automation Platform/Tower, setup Job Templates for the ansible/workshops, and auto-deploy the workshop for you.  Log into AAP/Tower to get the urls for your project.  You can also deploy workshops on the command line.

It takes 5 mins worth of work to have a fully usable AAP/Tower.

**REQUIRED**: You will need to have an AWS ec2 account and DNS zone setup in AWS Route 53. The setup script will guide you through most of the process but setting up a domain name in AWS is beyond the scope of this project.  Here is a link that will help you acquire a domain name in aws, or move your domain to aws: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html

# How

This should get you started on a RHEL8 system:

```shell
subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms
yum install git ansible python3-pip
python3-pip install boto boto3
git clone https://github.com/syspimp/deploy-workshop-workstation
cd deploy-workshop-workstation
chmod +x ./setup.sh
./setup.sh
```

Answer the questions and 5 mins later your VM is configuring itself.  Some trimmed output is below this discussion.

# Utilities description
*clean-workshop-configuration.sh*

This removes the group\_vars/all, ssh keys, and manifest. Restores to a clean environment

*edit-groupvars.sh*

This comman is wrapper to edit the encypted group\_vars/all

*restore-workshop.sh*

This restores a backed up workshop configuration

*setup.sh*

This configures group\_vars/all and launches the deployment

*stop-running-vms.sh*

This stops all vms in the workstation and workshop vpcs.

*destroy-workstation.sh*

This deletes/removes the workstation. Use after destroying the workshop or you may have cruft in your aws environment.

*rerun-ansible.sh*

Run this to reconfigure your workstation with ansible after you have already run ./setup.sh.

*save-workshop.sh*

This will backup your workshop configuration to saved/

*start-stopped-vms.sh*

This will start all of your stopped vms in the workstation and workshop vpcs.

# Example output
```shell
$ ./setup.sh

I am the helper program. I will guide you to get everything setup and deployed.

The ansible playbooks in this repo will:
- create vpc, subnet, gateway, security group, and a workstation vm
- clone the ansible/workshops repo and configure it per your settings
- install the latest Ansible Automation Platform on the workstation
- configure AAP with job templates, credentials, inventory, and surveys
  to deploy workshops at the click of a button

WORKSHOP DEPENDENCY: You will need a domain name configured in your AWS Route53 for the workshop deployment to succeed. You can still install just the workstation.

There are six steps. It shouldn't take you more than 5 mins:
1. Create manifest.zip file containing Ansible Automation Platform subscriptions and place it in ./files/
2. Collect your workshop details
3. Collect AWS credentials
4. Collect Redhat service account credentials
5. Encrypt your sensitive information
6. Deploy the workstation!

WARNING: This will modify your group_vars/all file.
Ready? Press enter to continue.


Please type a password to use to vault encrypt your sensitive information.
Do NOT use a password you use for anything else.
Vault Password: 4nything.3lse
Thanks! Saved in ./vault_secret.

Provide the workshop details.
Workshop types are:
- windows,
- rhel,
- rhel_90 (rhel in 90 minutes),
- security,
- network,
- f5,
- smart_mgmt,
- demo (installs all ansible demos but fails at the end)
The defaults will be displayed in [brackets]. Hit enter to accept.
Press enter when ready

Workshop Name [syspimp-workshop]: sears-catalog
Workshop Type [windows]: 
Number of Students for this workshop [2]: 
Required: AWS DNS Zone to use [none]: example.com
Default Password for students [ansible123]: 
Do you want to autolaunch this workshop when tower is installed [yes]? (yes or no) 
Step 2 Done!

I will now encrypt the manifest.
ERROR! input is already encrypted
Step 1 Done!

If you don't have one, you will need to visit url below to create AWS access keys.
When you have the access key and secret, press enter.

https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials

AWS Key ID: ABCDEFGHIJKKDXBQQ
AWS Secret Key: 1234567890gTWXPDmIi
Step 3 Done!

Enter your Redhat Customer Portal creds. Don't worry we will encrypt them. We will need to register the workstation.
Redhat Customer Portal username: syspimp@localhost
Redhat Customer Portal password: shadowman

Redhat Service Accounts are a way to access the redhat api without using your customer portal credentials.

Step 1 of 2: Visit https://access.redhat.com/terms-based-registry/#/accounts to create a service account/password
When you have the svc account/password, press enter.

Redhat Service Account User (looks like: 12345|your-name-here): 12345|workshop-demo
Redhat Service Accout Password: eyJhbGciOiJSUzUxMiJ9.eyJzdWIiOiIx...[snip]...POjvWskGdNuZTHAicKXdruLY3Z4s3DmqnxPRLwIoH3iiSi6azplmEUHqXOMXXXhQmhVplu3-HP5hweVF5DT-7HEaguIid9fb3Z1L7N5ICOp0Qoux5lFyu6sK-2YRIkfLusjUkPsDCePdI2X3YZRAqVRs1BJbDmdGENcj8unbmLtu0Peq05kE
Step 2 of 2: You will also need to generate an offline token by visiting the url below

https://access.redhat.com/management/api
When you have generated the offline token, press enter.

Redhat Offline Token: eyJhbGciOiJIUzI1NiIsInR5cCIgOi...[snip]...oib2ZmbGluZV9hY2Nlc3MifQ.yAnsdSOSmLenRGMXC3jICmwc5XzzBRlc4KWqknpTqeA
Step 4 Done!

I will now encrypt your sensitive info in group_vars/all.
Encryption successful
If you need to edit in the future, use the command: 
ansible-vault edit --vault-password-file ./vault_secret group_vars/all
Step 5 Done!

Step 6: Ready to deploy! Press enter to launch and configure your Workstation.

Installing ansible collections ...
Executing: ansible-playbook --vault-password-file ./vault_secret launch-workshop-workstation.yml
[WARNING]: While constructing a mapping from /home/dataylor/git/deploy-workshop-workstation/roles/deploy-workshop-
workstation/tasks/tower.yml, line 155, column 3, found a duplicate dict key (args). Using last defined value only.

PLAY [launch an instance in ec2] *******************************************************************************************************

TASK [Set the VM name] *****************************************************************************************************************
ok: [localhost]

TASK [Set the AMI to CentOS7] **********************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL6] ************************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL7] ************************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL8] ************************************************************************************************************
ok: [localhost]

TASK [Set the VM roles] ****************************************************************************************************************
ok: [localhost]

TASK [create VPC] **********************************************************************************************************************
changed: [localhost]

TASK [debug vpc] ***********************************************************************************************************************
ok: [localhost] => 
  vpc:
    changed: true
    failed: false
    vpc:
      cidr_block: 11.22.33.0/24
      cidr_block_association_set:
      - association_id: vpc-cidr-assoc-0f565c64256d09dba
        cidr_block: 11.22.33.0/24
        cidr_block_state:
          state: associated
      classic_link_enabled: false
      dhcp_options_id: dopt-a95a4dcc
      id: vpc-0c50f85e3237a4fa1
      instance_tenancy: default
      is_default: false
      owner_id: '698223370459'
      state: available
      tags:
        Name: sears-catalog vpc

TASK [associate subnet to the VPC] *****************************************************************************************************
changed: [localhost]

TASK [create IGW] **********************************************************************************************************************
changed: [localhost]

TASK [Route IGW] ***********************************************************************************************************************
changed: [localhost]

TASK [Create Security Group] ***********************************************************************************************************
changed: [localhost]

TASK [create a new ec2 key pair] *******************************************************************************************************
changed: [localhost]

TASK [Copy EC2 Private Key locally so it can be later on used to SSH into the instance] ************************************************
changed: [localhost]

TASK [See if workstation instance exists already] **************************************************************************************
ok: [localhost]
[.......]
TASK [deploy-workshop-workstation : Wait 5 to 11 mins for host to reboot] ************************************************************************************
skipping: [54.175.167.26]

TASK [deploy-workshop-workstation : Finished! Tower instructions] ********************************************************************************************
ok: [54.175.167.26] =>
  msg: Visit https://54.175.167.26/ using user/pass admin/ansible123. There are two Job Templates, Deploy Workshop and Destroy Workshop pre-configured.

TASK [deploy-workshop-workstation : Finished! CLI instructions] **********************************************************************************************
ok: [54.175.167.26] =>
  msg: ssh to ec2-user@54.175.167.26, cd to /home/ec2-user/workshops/provisioner, and execute ansible-playbook -e @workshop-demo-workshop.yml provision_lab.yml to launch your ansible workshop.

PLAY [Deploy the workshop] ***********************************************************************************************************************************

TASK [Kick off the deployment from tower] ********************************************************************************************************************
ok: [54.175.167.26]

PLAY RECAP ***************************************************************************************************************************************************
54.175.167.26              : ok=34   changed=13   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
localhost                  : ok=14   changed=1    unreachable=0    failed=0    skipped=7    rescued=0    ignored=0
```
