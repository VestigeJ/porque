$SERVER = Read-Host -Prompt 'input the server ip to connect this windows agent to: '
$TOKEN = Read-Host -Prompt 'paste in the token from the server nodes: '
$VERSION = Read-Host -Prompt 'paste the version to test: '
Write-Host "Setting up Windows agent, talking to...  '$SERVER"

Enable-WindowsOptionalFeature -Online -FeatureName Containers -All
New-Item -Type Directory c:/etc/rancher/rke2 -Force
Set-Content -Path c:/etc/rancher/rke2/config.yaml -Value @'
server: https://$SERVER:9345
token: $TOKEN
kube-proxy-arg: feature-gates=IPv6DualStack=false
'@
Invoke-WebRequest -Uri https://raw.githubusercontent.com/rancher/rke2/master/install.ps1 -Outfile [System.Environment]::CurrentDirectory\install.ps1 -Wait
#Invoke-RestMethod -Uri https://raw.githubusercontent.com/rancher/rke2/master/install.ps1 Add-Content [System.Environment]::CurrentDirectory\run-win-agent.ps1
& 'install.ps1' -Version $VERSION
& 'rke2.exe' agent service --add
Start-Service rke2
