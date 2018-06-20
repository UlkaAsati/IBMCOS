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
echo $ENV
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
$ENV:PATH="$ENV:PATH;c:\Program Files\Microsoft Service Fabric\bin\Fabric\Fabric.Code"
& "$ENV:ProgramFiles\Microsoft SDKs\Service Fabric\ClusterSetup\DevClusterSetup.ps1"
