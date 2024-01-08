#!/bin/bash

# vmsubnet Variables
resourceGroupName="PERSO_DRITON"
vmName="vmTony"
location="westeurope"
vmSize="Standard_B1s"
username="myadmin"
password="Its'ssecret.1"  
vnetName="tonyvnetwordpress"         
subnetName="vmsubnet"     
nsgName="vmnsg" 
sshKeyName="mysshkey"  # Name for the SSH key

# Resource group (
az group create --name $resourceGroupName --location $location

# VM details
az vm create \
    --resource-group $resourceGroupName \
    --name $vmName \
    --location $location \
    --size $vmSize \
    --image Ubuntu2204 \
    --admin-username $username \
    --admin-password $password \
    --vnet-name $vnetName \
    --subnet $subnetName \
    --nsg $nsgName \
    --ssh-key-value ~/.ssh/$sshKeyName.pub \
    --generate-ssh-keys 
    
    

echo "Virtual Machine '$vmName' has been created in resource group '$resourceGroupName' and added to subnet '$subnetName' in VNet '$vnetName'."
