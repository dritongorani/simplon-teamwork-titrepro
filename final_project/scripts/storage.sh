# Define variables
storageAccountName="tonystocreate"
resourceGroupName="PERSO_DRITON" 
location="westeurope"
sku="Standard_GRS"
containerName="mytfstatecontainer"
containerNameWordpress="mywordpresscontents"

# Create Azure Storage Account
az storage account create \
  --name $storageAccountName \
  --resource-group $resourceGroupName \
  --location $location \
  --sku $sku

# Create a container in the Azure Storage Account for tfstate
az storage container create \
  --name $containerName \
  --account-name $storageAccountName \
  --account-key "$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' --output tsv)"

# Change the access level for the tfstate container to 'container'
az storage container set-permission \
  --name $containerName \
  --public-access container \
  --account-name $storageAccountName \
  --account-key "$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' --output tsv)"

# Create a container in the Azure Storage Account for wordpress
az storage container create \
  --name $containerNameWordpress \
  --account-name $storageAccountName \
  --account-key "$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' --output tsv)"

# Change the access level for the wordpress container to 'container'
az storage container set-permission \
  --name $containerNameWordpress \
  --public-access container \
  --account-name $storageAccountName \
  --account-key "$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' --output tsv)"

# Set the container name as a variable (if needed)
containerVariable=$containerName

# Output the container name for verification
echo "Container name: $containerVariable"
