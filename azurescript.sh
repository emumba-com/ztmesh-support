#!/bin/bash

echo "Available Subscriptions:"
az account list --query "[].{Name:name, ID:id}" --output table
read -p "Enter the Subscription ID: " subscriptionId

# List available resource groups
echo "Available Resource Groups:"
az group list --subscription $subscriptionId --query "[].{Name:name}" --output table
read -p "Enter the Resource Group Name: " resourceGroupName

# Generate a timestamp
timestamp=$(date +'%m-%d-%Y-%H-%M-%S')
echo "Configuring service principle.... :"
# Create a service principal
servicePrincipalName="my-ZTNA-$timestamp"
roleName="Contributor"
scope="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"

# Create the service principal and assign a role
az ad sp create-for-rbac --name "$servicePrincipalName" --role "$roleName" --scopes "$scope"

sleep 30


# Get the service principal details
appId=$(az ad sp list --all --query "[?displayName == '$servicePrincipalName'].appId" --output tsv)
tenantID=$(az account show --query 'tenantId' -o tsv)
#aadAppClientId=$(az ad app show --id '$appId' --query 'appId' -o tsv)
aadAppClientSecret=$(az ad sp credential reset --id "$appId"  --query 'password' -o tsv)


# Get the user's object ID
userObjectId=$(az ad signed-in-user show --query id --output tsv)

# Print the outputs
echo" Please copy these outputs in azure-cloud integration fields" 
echo "Application Client ID: $appId"
echo "Subscription ID: $subscriptionId"
echo "Tenant ID: $tenantID"
echo "Application Client Secret: $aadAppClientSecret"
