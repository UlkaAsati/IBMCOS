#Install choco and microsoft zure service Fabric SDK

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install MicrosoftAzure-ServiceFabric-CoreSDK --source webpi --confirm

#Download and Unpack the standalone Service Fabric for Windows Server package to your machine

#wget https://github.com/UlkaAsati/IBMCOS/blob/master/Microsoft.Azure.ServiceFabric.WindowsServer.6.2.283.9494.zip?raw=true -outfile "C:\Microsoft.Azure.ServiceFabric.WindowsServer.6.2.283.9494.zip"
#cd C:\
#expand-archive -path Microsoft.Azure.ServiceFabric.WindowsServer.6.2.283.9494.zip -destinationpath '.\Microsoft.Azure.ServiceFabric.WindowsServer.6.2.283.9494'
#cd Microsoft.Azure.ServiceFabric.WindowsServer.6.2.283.9494

#write-host "Microsoft.Azure.ServiceFabric.WindowsServer.6.2.283.9494 downloaded"

#create a cluster

cd C:\
& "C:\ProgramFiles\Microsoft SDKs\Service Fabric\ClusterSetup\DevClusterSetup.ps1"

#.\CreateServiceFabricCluster.ps1 -ClusterConfigFilePath .\ClusterConfig.Unsecure.DevCluster.json -AcceptEULA


# Application deployment

#Step1: Import the Service Fabric SDK PowerShell module.

cd C:\

Import-Module "$ENV:ProgramFiles\Microsoft SDKs\Service Fabric\Tools\PSModule\ServiceFabricSDK\ServiceFabricSDK.psm1"

 #Step2: Create a directory to store the application that you download and deploy, such as C:\ServiceFabric.

mkdir c:\AppDeploy\
cd c:\AppDeploy\

write-host "created a dir to store application to be downloaded"

#step3: connect to cluster

Connect-ServiceFabricCluster localhost:19000

write-host "cluster created successfully"

# step4: download the publish.xml files and Rules Engine application to deploy

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
wget https://github.com/UlkaAsati/IBMCOS/blob/master/Apttus.RulesEngine-Package-4.0.0.91.zip?raw=true -outfile "C:\AppDeploy\Apttus.RulesEngine-Package-4.0.0.91.zip"
cd C:\AppDeploy\
expand-archive -path Apttus.RulesEngine-Package-4.0.0.91.zip -destinationpath '.\Apttus.RulesEngine-Package-4.0.0.91'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
wget https://github.com/UlkaAsati/IBMCOS/blob/master/ServiceFabric.zip?raw=true -outfile "C:\AppDeploy\ServiceFabric.zip"
cd C:\AppDeploy\
expand-archive -path ServiceFabric.zip -destinationpath '.\ServiceFabric' 

write-host "downloaded publish.xml and rules engine app"

# step5 : deploy the application

Connect-ServiceFabricCluster localhost:19000

.\ServiceFabric\Deploy-FabricApplication.ps1 -PublishProfileFile .\ServiceFabric\plat-dev-aql-PublishProfile.xml  -ApplicationPackagePath 'C:\AppDeploy\Apttus.RulesEngine-Package-4.0.0.91\Release' -Action 'Create' -OverwriteBehavior 'Always'

#open the browser to check the SF cluster and App
#step:1: disable the IE ESC

function Disable-ieESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
Disable-ieESC

# open SF cluster URI

$IE=new-object -com internetexplorer.application
 $IE.navigate2(" http://localhost:19080/Explorer/index.html")
 $IE.visible=$true
