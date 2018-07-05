#Install choco and microsoft zure service Fabric SDK

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install MicrosoftAzure-ServiceFabric-CoreSDK --source webpi --confirm


#create a cluster

cd C:\
echo $ENV
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
$ENV:PATH="$ENV:PATH;c:\Program Files\Microsoft Service Fabric\bin\Fabric\Fabric.Code"
& "$ENV:ProgramFiles\Microsoft SDKs\Service Fabric\ClusterSetup\DevClusterSetup.ps1"

#.\CreateServiceFabricCluster.ps1 -ClusterConfigFilePath .\ClusterConfig.Unsecure.DevCluster.json -AcceptEULA


# Application deployment

Connect-ServiceFabricCluster localhost:19000

#Step1: Import the Service Fabric SDK PowerShell module.

cd C:\

Import-Module "$ENV:ProgramFiles\Microsoft SDKs\Service Fabric\Tools\PSModule\ServiceFabricSDK\ServiceFabricSDK.psm1"

 #Step2: Create a directory to store the application that you download and deploy, such as C:\ServiceFabric.

mkdir c:\AppDeploy\
cd c:\AppDeploy\

write-host "created a dir to store application to be downloaded"

#step3: connect to cluster

#Connect-ServiceFabricCluster localhost:19000

#write-host "cluster created successfully"

# step3: download the publish.xml files and Rules Engine application to deploy

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

System.Net.ServicePointManager.Expect100Continue = false;

curl -v -H @{'X-JFrog-Art-Api'='AKCp5bAicvWg57NJqTy4oFwDWfW5HYAdm2BQJvMxYv22MypMEj3vJzuLXBgS3aqa4AerYQUmi'} 'https://art01.apttuscloud.io/aic/Apttus.RulesEngine/service-fabric/master/Apttus.RulesEngine-Package-1802.0.0.166.zip' -o "C:\AppDeploy\Apttus.RulesEngine-Package-1802.0.0.166.zip"
cd C:\AppDeploy\
expand-archive -path Apttus.RulesEngine-Package-1802.0.0.166.zip -destinationpath '.\Apttus.RulesEngine-Package-1802.0.0.166'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
System.Net.ServicePointManager.Expect100Continue = false;
curl -v -H @{'X-JFrog-Art-Api'='AKCp5bAicvWg57NJqTy4oFwDWfW5HYAdm2BQJvMxYv22MypMEj3vJzuLXBgS3aqa4AerYQUmi'} 'https://art01.apttuscloud.io/FoundryTest/plat-dev-aql-ApplicationParameters.xml' -o "C:\AppDeploy\plat-dev-aql-ApplicationParameters.xml"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
System.Net.ServicePointManager.Expect100Continue = false;
curl -v -H @{'X-JFrog-Art-Api'='AKCp5bAicvWg57NJqTy4oFwDWfW5HYAdm2BQJvMxYv22MypMEj3vJzuLXBgS3aqa4AerYQUmi'} 'https://art01.apttuscloud.io/FoundryTest/Deploy-FabricApplication.ps1' -o "C:\AppDeploy\Deploy-FabricApplication.ps1"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
System.Net.ServicePointManager.Expect100Continue = false;
curl -v -H @{'X-JFrog-Art-Api'='AKCp5bAicvWg57NJqTy4oFwDWfW5HYAdm2BQJvMxYv22MypMEj3vJzuLXBgS3aqa4AerYQUmi'} 'https://art01.apttuscloud.io/FoundryTest/plat-dev-aql-PublishProfile.xml' -o "C:\AppDeploy\plat-dev-aql-PublishProfile.xml"
 

write-host "downloaded publish.xml and rules engine app"

# step4 : deploy the application

[void](Connect-ServiceFabricCluster)
$global:clusterConnection = $clusterConnection

#.\ServiceFabric\Deploy-FabricApplication.ps1 -PublishProfileFile .\ServiceFabric\plat-dev-aql-PublishProfile.xml  -ApplicationPackagePath 'C:\AppDeploy\Apttus.RulesEngine-Package-4.0.0.91\Release' -Action 'Create' -OverwriteBehavior 'Always'
.\Deploy-FabricApplication.ps1 -PublishProfileFile .\plat-dev-aql-PublishProfile.xml -ApplicationPackagePath 'C:\AppDeploy\Apttus.RulesEngine-Package-1802.0.0.166\Release' -Action 'Create' -OverwriteBehavior 'Always'

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
