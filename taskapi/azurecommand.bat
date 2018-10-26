echo on
title "Executing Azure Common Commands to run in a fresh PowerShell Window"
call az login
call azure account set 0d4f44f5-e032-49de-ba6c-86dcf4201a31
call az provider register -n Microsoft.ContainerService
call az provider register -n Microsoft.Network
call az provider register -n Microsoft.Storage
call az provider register -n Microsoft.Compute
call az configure --defaults location=eastus
call az provider register --namespace Microsoft.DevSpaces
call az group create --name ais-azdevspace-rg --location eastus
title "Executing Azure Commands to create AKS Cluster and enabling http_application_routing"
call az aks create -g ais-azdevspace-rg -n taskapi-azds --location eastus --kubernetes-version 1.11.3 --node-count 2 --enable-addons http_application_routing
call az aks get-credentials --resource-group ais-azdevspace-rg --name taskapi-azds
title "Executing Azure Commands to create Azure DevSpaces Controller"
call az aks use-dev-spaces -g ais-azdevspace-rg -n taskapi-azds

:: title "Cleaning Steps"
:: call azds remove --resource-group ais-azdevspace-rg --name taskapi-azds

