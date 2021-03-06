# What

This will **deploy a workstation ready to deploy workshops via cli or ansible tower** in your aws account. It will setup a vpc, subnet, ssh keys, dns records, launch a new workstation running the latest Ansible Automation Platform/Tower, setup Job Templates for the ansible/workshops, and auto-deploy the workshop for you.  Log into AAP/Tower to get the urls for your project.  You can also deploy workshops on the command line.

It takes 5 mins worth of work to have a fully usable AAP/Tower.

**REQUIRED**: You will need to have an AWS ec2 account and DNS zone setup in AWS Route 53. The setup script will guide you through most of the process but setting up a domain name in AWS is beyond the scope of this project.  Here is a link that will help you acquire a domain name in aws, or move your domain to aws: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html

# How

This should get you started on a RHEL8 system:

```shell
sudo subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms
sudo yum -y install git ansible python3-pip
sudo pip3 install boto boto3
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
[syspimp@yogac940 deploy-workshop-workstation]$ ./setup.sh

                                                                  
                               88 88                              
                               88 88                       ,d     
                               88 88                       88     
8b,dPPYba,  ,adPPYba,  ,adPPYb,88 88,dPPYba,  ,adPPYYba, MM88MMM  
88P'   "Y8 a8P_____88 a8"    `Y88 88P'    "8a ""     `Y8   88     
88         8PP""""""" 8b       88 88       88 ,adPPPPP88   88     
88         "8b,   ,aa "8a,   ,d88 88       88 88,    ,88   88,    
88          `"Ybbd8"'  `"8bbdP"Y8 88       88 `"8bbdP"Y8   "Y888  
                                                                  
                                                                  

I am the helper program. I will guide you to get everything setup and deployed.

The ansible playbooks in this repo will:
- create vpc, subnet, gateway, security group, and a workstation vm
- clone the ansible/workshops repo and configure it per your settings
- install the latest Ansible Automation Platform on the workstation
- configure AAP with job templates, credentials, inventory, and surveys
  to deploy workshops at the click of a button

WORKSHOP DEPENDENCY: You will need a domain name configured in your AWS Route53 for the workshop deployment to succeed. You can still install just the workstation.

There are six steps. It shouldn't take you more than 5 mins:
1. Create manifest.zip file containing Ansible Automation Platform subscriptions and place it in roles/deploy-workshop-workstation/files/manifest.zip
2. Collect your workshop details
3. Collect AWS credentials
4. Collect Redhat service account credentials
5. Encrypt your sensitive information
6. Deploy the workstation!

WARNING: This will modify your group_vars/all file.
Ready? Press enter to continue.


Please type a password to use to vault encrypt your sensitive information.
Do NOT use a password you use for anything else.
Vault Password: for.github.readme
Thanks! Saved in ./vault_secret.

_.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.


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

Workshop Name [\$USER-workshop]: 
Workshop Type [windows]: 
Number of Students for this workshop [2]: 
Required: AWS DNS Zone to use [none]: example.com
Default Password for students [ansible123]: 
Do you want to autolaunch this workshop when tower is installed [yes]? (yes or no) 
Step 1 Done!

_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_

Ansible Automation Platform uses Satellite-style entitlements manifests
You need to visit the url below to create a Satellite 6.8 manifest. Add Ansible Automation Platform subscriptions to it.

Download/export the manifest, name it manifest.zip and COPY it to ./roles/deploy-workshop-workstation/files/manifest.zip
https://access.redhat.com/management/subscription_allocations

Press enter when this is complete. I'll check again. Or Ctrl-C and start again when ready.
^C
[syspimp@yogac940 deploy-workshop-workstation]$
(reverse-i-search)`mani': cp /home/syspimp/Downloads/manifest_ansible_20210811T145521Z.zip roles/deploy-workshop-workstation/files/manifest.zip
[syspimp@yogac940 deploy-workshop-workstation]$ ./setup.sh


                                                                  
                               88 88                              
                               88 88                       ,d     
                               88 88                       88     
8b,dPPYba,  ,adPPYba,  ,adPPYb,88 88,dPPYba,  ,adPPYYba, MM88MMM  
88P'   "Y8 a8P_____88 a8"    `Y88 88P'    "8a ""     `Y8   88     
88         8PP""""""" 8b       88 88       88 ,adPPPPP88   88     
88         "8b,   ,aa "8a,   ,d88 88       88 88,    ,88   88,    
88          `"Ybbd8"'  `"8bbdP"Y8 88       88 `"8bbdP"Y8   "Y888  
                                                                  
                                                                  

You are rerunning the setup.sh script. If you want to run the ansible playbook 
without changing the workshop setup or your credentials, then run 
'./rerun-ansible.sh'
You only need to run setup.sh to setup your credentials.

If you want to edit your credentials or workshop setup in the group_vars/all file, then run
'./edit-groupvars.sh'

To continue, I need to restore the group_vars/all back to the original 
and if the manifest has been encrypted, you should use the same vault password.

If you don't want this, Ctrl-C now. Otherwise, press enter to continue


I am the helper program. I will guide you to get everything setup and deployed.

The ansible playbooks in this repo will:
- create vpc, subnet, gateway, security group, and a workstation vm
- clone the ansible/workshops repo and configure it per your settings
- install the latest Ansible Automation Platform on the workstation
- configure AAP with job templates, credentials, inventory, and surveys
  to deploy workshops at the click of a button

WORKSHOP DEPENDENCY: You will need a domain name configured in your AWS Route53 for the workshop deployment to succeed. You can still install just the workstation.

There are six steps. It shouldn't take you more than 5 mins:
1. Create manifest.zip file containing Ansible Automation Platform subscriptions and place it in roles/deploy-workshop-workstation/files/manifest.zip
2. Collect your workshop details
3. Collect AWS credentials
4. Collect Redhat service account credentials
5. Encrypt your sensitive information
6. Deploy the workstation!

WARNING: This will modify your group_vars/all file.
Ready? Press enter to continue.


Please type a password to use to vault encrypt your sensitive information.
Do NOT use a password you use for anything else.
Vault Password: for.github.readme
Thanks! Saved in ./vault_secret.

_.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~._.~"~.


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

Workshop Name [dataylor-workshop]: 
Workshop Type [windows]: 
Number of Students for this workshop [2]: 
Required: AWS DNS Zone to use [none]: example.com
Default Password for students [ansible123]: 
Do you want to autolaunch this workshop when tower is installed [yes]? (yes or no) 
Step 1 Done!

_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_.~"(_

I will now encrypt the manifest.
Encryption successful
Step 2 Done!

//\(oo)/\\     //\(oo)/\\     //\(oo)/\\     //\(oo)/\\     //\(oo)/\\     //\(oo)/\\     //\(oo)/\\     //\(oo)/\\     //\(oo)/\\


If you don't have one, you will need to visit url below to create AWS access keys.
When you have the access key and secret, press enter.

https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials

AWS Key ID: AKIA...[snip]...KDXBQQ
AWS Secret Key: Itzn27...[snip]...sw/SkGo+DIi
Step 3 Done!

[($)]          [($)]          [($)]          [($)]          [($)]          [($)]          [($)]          [($)]          [($)]


Enter your Redhat Customer Portal creds. Don't worry we will encrypt them. We will need to register the workstation.
Redhat Customer Portal username: syspimp@local
Redhat Customer Portal password: SuperSecretPassword

Redhat Service Accounts are a way to access the redhat api without using your customer portal credentials.

Step 1 of 2: Visit https://access.redhat.com/terms-based-registry/#/accounts to create a service account/password
When you have the svc account/password, press enter.

Redhat Service Account User (looks like: 12345|your-name-here): 123456|workshop-demo
Redhat Service Accout Password: eyJhbGciOiJSUzUxMiJ9.eyJzdWIiOiIxNzQwO...[snip]...Rs1BJbDmdGENcj8unbmLtu0Peq05kE
Step 2 of 2: You will also need to generate an offline token by visiting the url below

https://access.redhat.com/management/api
When you have generated the offline token, press enter.

Redhat Offline Token: eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldU...[snip]...LenRGMXC3jICmwc5XzzBRlc4KWqknpTqeA
Step 4 Done!

=^_^=          =^_^=          =^_^=          =^_^=          =^_^=          =^_^=          =^_^=          =^_^=          =^_^=


I will now encrypt your sensitive info in group_vars/all.
Encryption successful
If you need to edit in the future, use the command: 
ansible-vault edit --vault-password-file ./vault_secret group_vars/all
Step 5 Done!

<3             <3             <3             <3             <3             <3             <3             <3             <3

Step 6: Ready to deploy! Press enter to launch and configure your Workstation.

Installing ansible collections ...
Executing: ansible-playbook --vault-password-file ./vault_secret launch-workshop-workstation.yml
[WARNING]: While constructing a mapping from /home/syspimp/git/deploy-workshop-workstation/roles/deploy-workshop-workstation/tasks/tower.yml, line 155,
column 3, found a duplicate dict key (args). Using last defined value only.

PLAY [launch an instance in ec2] *****************************************************************************************************************************

TASK [Set the VM name] ***************************************************************************************************************************************
ok: [localhost]

TASK [Set the AMI to CentOS7] ********************************************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL6] **********************************************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL7] **********************************************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL8] **********************************************************************************************************************************
ok: [localhost]

TASK [Set the VM roles] **************************************************************************************************************************************
ok: [localhost]

TASK [create VPC] ********************************************************************************************************************************************
changed: [localhost]

TASK [debug vpc] *********************************************************************************************************************************************
ok: [localhost] => 
  vpc:
    changed: true
    failed: false
    vpc:
      cidr_block: 11.22.33.0/24
      cidr_block_association_set:
      - association_id: vpc-cidr-assoc-0b45771c3757cc88f
        cidr_block: 11.22.33.0/24
        cidr_block_state:
          state: associated
      classic_link_enabled: false
      dhcp_options_id: dopt-a95a4dcc
      id: vpc-0f17d3faa33ce594a
      instance_tenancy: default
      is_default: false
      owner_id: '698223370459'
      state: available
      tags:
        Name: syspimp-workshop vpc

TASK [associate subnet to the VPC] ***************************************************************************************************************************
changed: [localhost]

TASK [create IGW] ********************************************************************************************************************************************
changed: [localhost]

TASK [Route IGW] *********************************************************************************************************************************************
changed: [localhost]

TASK [Create Security Group] *********************************************************************************************************************************
changed: [localhost]

TASK [create a new ec2 key pair] *****************************************************************************************************************************
changed: [localhost]

TASK [Copy EC2 Private Key locally so it can be later on used to SSH into the instance] **********************************************************************
changed: [localhost]

TASK [See if workstation instance exists already] ************************************************************************************************************
ok: [localhost]

TASK [debug instances] ***************************************************************************************************************************************
ok: [localhost] => 
  wrkshop_instances:
    changed: false
    failed: false
    instances: []

TASK [launch an ec2 instance in a vpc subnet] ****************************************************************************************************************
changed: [localhost]

TASK [Save the public ip from the old deployment] ************************************************************************************************************
skipping: [localhost]

TASK [Save the public ip from the new deployment] ************************************************************************************************************
ok: [localhost]

TASK [Add new instance to host group] ************************************************************************************************************************
changed: [localhost]

TASK [Wait 2 to 11 mins for host to boot] ********************************************************************************************************************

[.......]

TASK [deploy-workshop-workstation : import the workshop objects] *********************************************************************************************
changed: [35.175.xxx.xxx] => (item=projects)
changed: [35.175.xxx.xxx] => (item=credentials)
changed: [35.175.xxx.xxx] => (item=job_templates)
changed: [35.175.xxx.xxx] => (item=inventory)
changed: [35.175.xxx.xxx] => (item=inventory_sources)

TASK [deploy-workshop-workstation : Reboot.] *****************************************************************************************************************
changed: [35.175.xxx.xxx]

TASK [deploy-workshop-workstation : idempotency for workshop] ************************************************************************************************
[WARNING]: Consider using the file module with state=touch rather than running 'touch'.  If you need to use command because file is insufficient you can add
'warn: false' to this command task or set 'command_warnings=False' in ansible.cfg to get rid of this message.
changed: [35.175.xxx.xxx]

TASK [deploy-workshop-workstation : Wait 5 to 11 mins for host to reboot] ************************************************************************************
ok: [35.175.xxx.xxx]

TASK [deploy-workshop-workstation : Finished! Tower instructions] ********************************************************************************************
ok: [35.175.xxx.xxx] => 
  msg: Visit https://35.175.xxx.xxx/ using user/pass admin/ansible123. There are two Job Templates, Deploy Workshop and Destroy Workshop pre-configured.

TASK [deploy-workshop-workstation : Finished! CLI instructions] **********************************************************************************************
ok: [35.175.xxx.xxx] => 
  msg: Your sshkey is keys/key.ppk. ssh -i keys/key.ppk ec2-user@35.175.xxx.xxx, cd to /home/ec2-user/workshops/provisioner, and execute ansible-playbook -e @workshop-demo-workshop.yml provision_lab.yml to launch your ansible workshop.

PLAY [Deploy the workshop] ***********************************************************************************************************************************

TASK [Kick off the deployment from tower] ********************************************************************************************************************
ok: [35.175.xxx.xxx]

PLAY RECAP ***************************************************************************************************************************************************
35.175.xxx.xxx              : ok=37   changed=28   unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
localhost                  : ok=17   changed=9    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0   

Success! A workshop is being built for you at the URL in the ansible output above.
When you are finished with the workshop, delete everything by running:
./destroy.sh
You can redeploy the workshop again by running
./rerun-ansible.sh
Have fun! (^_^) [o_o] (^.^)  (".") ($.$)

[syspimp@yogac940 deploy-workshop-workstation]$ ssh -i keys/key.ppk ec2-user@35.175.xxx.xxx
Warning: Permanently added '123.234.xxx.xxx' (ECDSA) to the list of known hosts.

                               88 88
                               88 88                       ,d
                               88 88                       88
8b,dPPYba,  ,adPPYba,  ,adPPYb,88 88,dPPYba,  ,adPPYYba, MM88MMM
88P'   "Y8 a8P_____88 a8"    `Y88 88P'    "8a ""     `Y8   88
88         8PP""""""" 8b       88 88       88 ,adPPPPP88   88
88         "8b,   ,aa "8a,   ,d88 88       88 88,    ,88   88,
88          `"Ybbd8"'  `"8bbdP"Y8 88       88 `"8bbdP"Y8   "Y888


[default]
role=deploy-workshop-workstation
This system is not registered to Red Hat Insights. See https://cloud.redhat.com/
To register this system, run: insights-client --register

Last login: Fri Aug 20 20:52:57 2021 from 123.234.xxx.xxx
[ec2-user@ip-11-22-33-154 ~]$ ls /home/ec2-user/
workshops
[ec2-user@ip-11-22-33-154 ~]$ logout
Connection to 35.175.xxx.xxx closed.
[sysimp@yogac940 deploy-workshop-workstation]$ ./destroy-workstation.sh

PLAY [destroy workshop resources] ****************************************************************************************************************************

TASK [Set the VM name] ***************************************************************************************************************************************
ok: [localhost]

TASK [Set the AMI to CentOS7] ********************************************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL6] **********************************************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL7] **********************************************************************************************************************************
skipping: [localhost]

TASK [Set the AMI to RHEL8] **********************************************************************************************************************************
ok: [localhost]

TASK [Set the VM roles] **************************************************************************************************************************************
ok: [localhost]

TASK [Gather information about any instance with a tag key Name: syspimp-workstation] *********************************************************************************************
ok: [localhost]

[.......]

TASK [wait a minute, give it time to delete] *****************************************************************************************************************
Pausing for 60 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [localhost]

TASK [disassociate subnet to the VPC] ************************************************************************************************************************
changed: [localhost]

TASK [destroy IGW] *******************************************************************************************************************************************
changed: [localhost]

TASK [Destroy Security Group] ********************************************************************************************************************************
changed: [localhost]

TASK [Destroy ec2 key pair] **********************************************************************************************************************************
changed: [localhost]

TASK [Destroy the VPC] ***************************************************************************************************************************************
changed: [localhost]

PLAY RECAP ***************************************************************************************************************************************************
localhost                  : ok=18   changed=7    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

[syspimp@yogac940 deploy-workshop-workstation]$ ./clean-workshop-configuration.sh

This will clean/remove your workshop configuration.
You will need to tell me EXPLICITLY 'yes' to remove your workshop configuration.
Usage: ./clean-workshop-configuration.sh yes
Example: ./clean-workshop-configuration.sh yes


[syspimp@yogac940 deploy-workshop-workstation]$ ./clean-workshop-configuration.sh yes

WARNING: This is will REMOVE any workshop configuration you have in the following files:
- ./vault_secret
- group_vars/all
- roles/deploy-workshop-workstation/files/manifest.zip
- keys/key.ppk

The manifest.zip will be deleted! I hope you have an unencrypted copy.

If you want to save those files, Ctrl-C now and run ./save-workshop.sh
Press enter to restore everything back to default



Success! You may now run './setup.sh' to deploy a workshop.

[syspimp@yogac940 deploy-workshop-workstation]$
```
