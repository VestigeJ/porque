$SERVER = Read-Host -Prompt 'input the server ip to connect this windows agent to: '
$TOKEN = Read-Host -Prompt 'paste in the token from the server nodes: '
$VERSION = Read-Host -Prompt 'paste the version to test: '
Write-Host "Setting up Windows agent, talking to the server at... '$SERVER"

Enable-WindowsOptionalFeature -Online -FeatureName Containers -All
New-Item -Type Directory c:/etc/rancher/rke2 -Force
Set-Content -Path c:/etc/rancher/rke2/config.yaml -Value @'
server: https://$SERVER:9345
token: $TOKEN
kube-proxy-arg: feature-gates=IPv6DualStack=false
'@
Invoke-WebRequest -Uri https://raw.githubusercontent.com/rancher/rke2/master/install.ps1 -Outfile C:\Users\Administrator\install.ps1
& 'C:\Users\Administrator\install.ps1' -Version $VERSION
& 'rke2.exe' agent service --add
Restart-Service rke2
