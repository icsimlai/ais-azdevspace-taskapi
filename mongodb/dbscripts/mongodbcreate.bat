echo on
::  Uncomment the following lines if running the script from a fresh PowerShell Window
::  call az login
::  call azure account set 0d4f44f5-e032-49de-ba6c-86dcf4201a31
::  call Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
::  call az provider register -n Microsoft.ContainerService
::  call az provider register -n Microsoft.Network
::  call az provider register -n Microsoft.Storage
::  call az provider register -n Microsoft.Compute
::  call az configure --defaults location=eastus
::  call az aks get-credentials --resource-group ais-azdevspace-rg --name taskapi-azds

title "Executing Mongo DB Creation Commands"
call .\generate.sh
call .\configure_repset_auth_dev.sh abc123

title "Executing Mongo DB Verification Commands"
call kubectl get statefulset --namespace dev
call  kubectl get pvc --namespace dev

:: title "Cleaning Steps"
:: call .\delete_service.sh
