[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
wget https://github.com/UlkaAsati/IBMCOS/blob/master/MicrosoftAzure-ServiceFabric-CoreSDK.exe?raw=true -outfile "C:\MicrosoftAzure-ServiceFabric-CoreSDK.exe" -UseBasicParsing; Start-Process "C:\MicrosoftAzure-ServiceFabric-CoreSDK.exe" -ArgumentList '/AcceptEULA', '/QUIET' -NoNewWindow -Wait; \
