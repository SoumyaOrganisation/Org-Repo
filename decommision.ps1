#Parameters to pass from catalog
$vmname = "LinuxCI74"  
 
#Connecting to Azure
$username1 = 'netdevopsid@netcon.in'
 
$password1 = 'D3v0ps@321'
 
$pass1= ConvertTo-SecureString $password1 -AsPlainText -Force
 
$azure_cred = New-Object System.Management.Automation.PsCredential( $username1, $pass1 )
 
$connect=Connect-AzAccount -Credential $azure_cred -WarningAction Ignore -Confirm:$false -Tenant "3865b44b-651f-4df8-a0c8-2625494f6198" -Subscription "5cce2d40-3f19-4810-8ead-4ad4c2d974dd" 
#Fetching Resource groupname of VM
$rg = Get-AzVM  -Name $vmname
$resourcegroup = $rg.ResourceGroupName
#Fetching NIC of VM
$vm = Get-AzVm -ResourceGroupName $resourcegroup -Name $vmname
$nic = Get-AzNetworkInterface | Where {$_.Id -eq $vm.NetworkProfile.NetworkInterfaces[0].Id}
$nicname = $nic.Name
#Deleting Vm
$removevm=Remove-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Force

#Deleting NIC from Resource group
$delnic = Remove-AzNetworkInterface -Name $nicname -ResourceGroupName $resourcegroup -Force
 
#Fetching OS disk name of vm
 
$diskname = $vm.StorageProfile.OsDisk.Name
#Deleting OS disk
$deldisk = Remove-AzDisk -ResourceGroupName $resourcegroup -DiskName $diskname -Force


# Check if the VM is using managed disks
if ($vm.StorageProfile.OsDisk.ManagedDisk) {
   Write-Output "The VM uses managed disks. No storage account is associated."
} else {
   Write-Output "The VM uses unmanaged disks."
}

# Get the OS Disk configuration
$osDisk = $vm.StorageProfile.OsDisk.ManagedDisk.Id
# If it's an unmanaged disk, get the storage account name
if (-not $osDisk.ManagedDisk) {
   $osDiskDetails = Get-AzDisk | Where-Object { $_.Id -eq $osDisk.Id }
   $storageAccountId = $osDiskDetails.ManagedBy
   $storageAccountName = (Get-AzStorageAccount | Where-Object { $_.Id -eq $storageAccountId }).StorageAccountName
   Write-Output "Storage Account Name: $storageAccountName"
} else {
   Write-Output "The VM is using managed disks; no storage account is associated."
}