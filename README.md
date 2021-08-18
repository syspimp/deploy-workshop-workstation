What
This will deploy a workstation ready to deploy workshops via cli or ansible tower.

How
This should get you started on a RHEL8 system:

`subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms`
`yum install git ansible python3`
`git clone https://github.com/syspimp/deploy-workshop-workstation`
`cd deploy-workshop-workstation`
`chmod +x ./deploy.sh`
`./deploy.sh`

Answer the questions and 5 mins later your VM is configuring itself.
