#Logs into an Azure subscription
Login-AzureRmAccount

#Selects the Azure subscription
Select-AzureRmSubscription -Subscription "<insert-subscriptionId-guid-here>"

#Creates a new Azure ResourceGroup
New-AzureRmResourceGroup -Name ajgPoSh -Location EastUS

#Creates virtual network
$virtualNetwork = New-AzureRmVirtualNetwork `
  -ResourceGroupName ajgPoSh `
  -Location EastUS `
  -Name poshVnet `
  -AddressPrefix 10.0.0.0/16

#Creates a subnet configuration within virtual network
$subnetConfig = Add-AzureRmVirtualNetworkSubnetConfig `
  -Name default `
  -AddressPrefix 10.0.0.0/24 `
  -VirtualNetwork $virtualNetwork

#Creates a subnet  within the virtual network
$virtualNetwork | Set-AzureRmVirtualNetwork

#Creates VM1  in Azure
New-AzureRmVm `
    -ResourceGroupName "ajgPoSh" `
    -Location "East US" `
    -VirtualNetworkName "poshVnet" `
    -SubnetName "subnet1" `
    -Name "Vm1" `
    -AsJob

#Creates VM2 in Azure
New-AzureRmVm `
  -ResourceGroupName "ajgPoSh" `
  -VirtualNetworkName "poshVnet" `
  -SubnetName "subnet1" `
  -Name "Vm2"
  -AsJob

#Gets IP Address of VM1
Get-AzureRmPublicIpAddress `
  -Name myVm1 `
  -ResourceGroupName ajgPoSh `
  | Select IpAddress

#Gets IP Address of VM2
Get-AzureRmPublicIpAddress `
  -Name myVm2 `
  -ResourceGroupName ajgPoSh `
  | Select IpAddress

#Initiates RDP prompt to connect to Windows VM
mstsc /v:137.117.68.64
mstsc /v:23.96.86.249

#Run against VM2
New-NetFirewallRule –DisplayName “Allow ICMPv4-In” –Protocol ICMPv4

#Removes Resource Group
Remove-AzureRmResourceGroup -Name ajgPoSh -Force