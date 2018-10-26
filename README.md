# Azure Dev Spaces Features Demonstration
This is the readme document for the Demo of Azure Dev Spaces(AZDS). AZDS is an Azure developer service that helps development teams develop with speed on Kubernetes. [Click here for more information.](https://aka.ms/signup-azds) . There are three modules in this series of demo which will show how to create a AZDS Controller, enable HTTP Application Routing and explore various features of AZDS. The demonstration is going to be done in an AKS Cluster that is created during the demo.  Setting up AZDS into an existing AKS Cluster is not in scope. The demo uses AZDS and a C#/.NET Core application deployed to target an AKS Cluster and show how the AZDS synchs up files with the cluster, builds the image and deploys to the same. It also shows how VS Code with AZDS is be used to debug an Application deployed to the Cluster. 

**Implementation**: 
We create an AKS Cluster and a AZDS Controller in AKS Master Node. Then the artifacts like chart files, docker file and YAML file are created using "azds prep" command. Then the code files are synched, built and deployed to AKS Cluster using "azds up" command. Finally, we demo the debugging of the code running in AKS Custer.

**Pre-requisites:**
- Azure CLI version 2.0.43 or higher installed in the machine where the Kubectl Client will run. It can be installed from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
- Visual Studio Code installed
- AzPowerShell in Admin mode to execute 'Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned'
- AKS cluster to have Kubernetes 1.9.6 or later, in the EastUS, CentralUS, WestUS2, WestEurope, CanadaCentral, or CanadaEast region, with Http Application Routing enabled.

<b>References:</b>
  Product documentation is hosted here: http://aka.ms/get-azds.

**Steps**:

For Pre-requisites follow the below steps:
1) Install latest version of Visual Studio Code

2) Check the current Azure CLI Version using the below command in Power Shell: 
> az –version

3) If the Azure CLI Version is less than 2.0.43, use ‘chocolatey’ to upgrade CLI Version to 2.0.46. 
> Open a “Cmd Window” in Admin Mode and run the below command:
  C:\ProgramData\chocolatey\bin> choco upgrade azure-cli

**Create AKS Cluster and AZDS Controller in AKS Master Node:**  
Open a new Azure CLI command Window and execute the following commands:

> Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

> az login          <-- Follow the steps in popped up browser window there will be UI for authentication

> az account list   <-- From the list note down the Subscription Id where the Cluster will be running

> azure account set [ SubscriptionId ]  <-- Feed the Subscription Id noted from above step

> az provider register -n Microsoft.ContainerService  <-- Register the necessary Providers for Azure  
> az provider register -n Microsoft.Network  
> az provider register -n Microsoft.Storage  
> az provider register -n Microsoft.Compute  
> az provider register -n Microsoft.DevSpaces  
> az configure --defaults location=eastus  

> az group create --name [ myResourceGroup ] --location eastus  <-- Create the Resource Group for AZDS Demo

> az aks create -g [ myResourceGroup ] -n taskapi-azds --location eastus --kubernetes-version 1.11.3 --node-count 2 --enable-addons http_application_routing  <-- Create AKS Cluster and enable routing

> az aks get-credentials --resource-group [ myResourceGroup ] --name taskapi-azds <-- Merge "taskapi-azds" as current context in ..\.kube\config

After the cluster is created, use the below command to view the DNS zone name. This is used to deploy applications to the AKS cluster:
> az aks show --resource-group [ myResourceGroup ] --name taskapi-azds --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table

Finally, use the below command to create the Controller
> az aks use-dev-spaces -g [ myResourceGroup ] -n taskapi-azds  <-- Create AZDS Controller in AKS Master Node

**Create AZDS artifacts:**

1) Change Current working directory in PowerShell window to the location where the Code exists
2) Execute the below command  
> azds prep 

**Build and Deploy the Code to AKS Cluster using AZDS artifacts:**

1) Execute the below command
> azds up

**Imp. Note 1:** 
Keep an eye on the above command's output, you'll notice several things as it progresses. If you get error like "Oops... An unexpected error has occurred. A report of the error will be sent to Microsoft." then stop here, do not execute this command in PowerShell. The following things are expected to happen,
- Source code is synced to the dev space in Azure.
- A container image is built in Azure, as specified by the Docker assets in your code folder.
- Kubernetes objects are created that utilize the container image as specified by the Helm chart in your code folder.
- Information about the container's endpoint(s) is displayed. In our case, we're expecting a public HTTP URL.
- Assuming the above stages complete successfully, you should begin to see stdout (and stderr) output as the container starts up

1) Launch "VS Code" and click "View --> Terminal"
2) Change current directory to Source Code directory in  "VS Code" Terminal and execute the below command,
> azds up

**Imp. Note 2:** 
You should see the output something like below,  
Executing task: C:\Program Files\Microsoft SDKs\Azure\Azure Dev Spaces CLI (Preview)\azds.exe up --await-exec --keep-alive <

Using dev space 'dev' with target 'taskapi-azds'  
Synchronizing files...2s  
Installing Helm chart...1s  
Waiting for container image build...10s  
Building container image...  
Step 1/12 : FROM microsoft/aspnetcore-build:2.0  
...  
Step 12/12 : ENTRYPOINT /bin/bash /entrypoint.sh  
Built container image in 17s  
Waiting for container...5s  
Service 'aisazdevspace-taskapi' port 'http' is available at http://aisazdevspace-taskapi.d347b30b61044bd39923.eastus.aksapp.io/ <-- URL is a sample example  
Service 'aisazdevspace-taskapi' port 80 (TCP) is available at http://localhost:60250  
Terminal will be reused by tasks, press any key to close it.

**Imp. Note 3:**  
As the AZDS is in Preview sometimes unexpected things may occur. You may see some messages like,
- Container cannot be reached
- Error 'Service cannot be started.'
- DNS name resolution fails for a public URL associated with a Dev Spaces service
- Error: 'The pipe program 'azds' exited unexpectedly with code 126.'
- Error: 'could not find a ready tiller pod' when launching Dev Spaces
Resolutions to these errors can be found in the link "https://docs.microsoft.com/en-us/azure/dev-spaces/troubleshooting#error-the-pipe-program-azds-exited-unexpectedly-with-code-126" 


Copy the Service link and appended "/swagger" with the URL to browse the Application deployed in AKS cluster. The Task API Application Page should show once the Application is started. Before we start the Application we need to install the MongoDB for the Application to connect to the backend. To install the MongoDB please follow the steps below,

**Mongo DB Installation:**

1) Change Current working directory to “...\GitHub\dev-spaces\mongodb\dbscripts” and execute the Script '.\generate.sh’ in PowerShell.  


> .\generate.sh     <-- Create the Mongo DB
secret "shared-bootstrap-data" created  
service "mongodb-service" created  
statefulset "mongod" created  
NAME             TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE  
svc/kubernetes   ClusterIP   10.0.0.1     <none>        443/TCP   1h  
   
**Imp. Note 4:** Keep an eye on the command's output
- There should not be any error. Output should look like the samples given below each command
- “configure_repset_auth_dev.sh” should be used if TaskApi is in “dev” namespace
- Verification Steps should be performed and should be ok

> .\configure_repset_auth_dev.sh abc123      <-- Configure the Mongo DB for Authentication  
Configuring the MongoDB Replica Set  
MongoDB shell version v3.6.8  
connecting to: mongodb://127.0.0.1:27017  
MongoDB server version: 3.6.8  
{ "ok" : 1 }  
Waiting for the Replica Set to initialise...  

**Mongo DB Installation Verification:**

**Steps**:
> kubectl get statefulset --namespace dev  
NAME      DESIRED   CURRENT   AGE  
mongod    2         2         7m  
> kubectl get pvc --namespace dev  
NAME                                        STATUS    VOLUME                                     CAPACITY   ACCESS MODES    STORAGECLASS   AGE  
mongodb-persistent-storage-claim-mongod-0   Bound     pvc-5afad54f-d8ea-11e8-bc5c-1269af54453f   1Gi        RWO            default        8m  
mongodb-persistent-storage-claim-mongod-1   Bound     pvc-9d85c669-d8ea-11e8-bc5c-1269af54453f   1Gi        RWO            default        6m  


**AZDS Features Demo**


Test – 1: Run the Application from VS Code
- Hit F5 in the VS Code and wait till you see the “Terminal will be reused by tasks, press any key to close it. ” in Terminal window of VS Code
- Browse the http://aisazdevspace-taskapi.d347b30b61044bd39923.eastus.aksapp.io/swagger URL in a browser and test the Task API Application to verify that it works with backend DB as expected e.g., create an User , "Task List", Task  ...
- Once the test is complete press any key in Terminal window of VS Code to close the application running


Test – 2: Change Code that needs compilation  
- Open the “..\GitHub\dev-spaces\aisazdevspace-taskapi\appsettings.json”) ” and change the comment.
- Run the “azds up” to see the code is rebuilt and automatically synched with AKS Containers. Wait till you see the message "Application started. Press Ctrl+C to shut down." in Terminal window  
- Refresh the http://aisazdevspace-taskapi.d347b30b61044bd39923.eastus.aksapp.io/swagger URL in the browser and see that the comment is updated
- Once the test is complete press "Ctrl + C"

Test – 3: Debug the Code running in AKS Cluster  
- Open the “..\GitHub\dev-spaces\aisazdevspace-taskapi\Controllers\UserController.cs”) ” and set a break point to the below function,  
      public User Get(string email)
        {
        }  
- Hit F5 in the VS Code and wait till you see the “Terminal will be reused by tasks, press any key to close it. ” 
- Browse the http://aisazdevspace-taskapi.d347b30b61044bd39923.eastus.aksapp.io/swagger URL in a browser and click the "Get" button under "User" section.  Verify that the debugger stops at the break point in the above function. Check the call Stack and variable values...  
- Once the test is complete stop the debugger and press any key in Terminal window of VS Code to close  the application running


**Cleanup Steps:**  
--
1) Execute the below command in PowerShell  
    > azds remove --resource-group [ myResourceGroup ] --name taskapi-azds  
    
2) Once the above command is executed, delete the Resource Groups created from the Azure Portal. 


**Other AZDS Features Demo:**

1) There are other Features available in Preview like Team Development. Please go through MS Documentation for the same


Note: There may be some documentation bug found while trying out the stuff in this series. Please send me input and it will be resolved asap.


