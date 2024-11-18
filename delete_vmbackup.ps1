$username1 = 'netdevopsid@netcon.in'
 
$password1 = 'D3v0ps@321'
 
$pass1= ConvertTo-SecureString $password1 -AsPlainText -Force
 
$azure_cred = New-Object System.Management.Automation.PsCredential( $username1, $pass1 )
 
$connect=Connect-AzAccount -Credential $azure_cred -WarningAction Ignore -Confirm:$false -Tenant "3865b44b-651f-4df8-a0c8-2625494f6198" -Subscription "5cce2d40-3f19-4810-8ead-4ad4c2d974dd"
$vault_name="Decomissonvault"
$vmName = "LinuxCI75"
$resourcegroup="CIRG-33"

##############Create a new service vault#####################################
$service_vault = New-AzRecoveryServicesVault -ResourceGroupName "$resourcegroup" -Name $vault_name -Location "CentralIndia" 
 
 
$targetVaultID = Get-AzRecoveryServicesVault -ResourceGroupName "$resourcegroup" -Name $vault_name | select -ExpandProperty ID
 
################################Set the vault context entering the vault ############################################
Get-AzRecoveryServicesVault -Name $vault_name | Set-AzRecoveryServicesVaultContext -WarningAction SilentlyContinue
 
 
##############Redundancy config#############################
 
Get-AzRecoveryServicesVault -Name $vault_name | Set-AzRecoveryServicesBackupProperty -BackupStorageRedundancy GeoRedundant -WarningAction SilentlyContinue
 
 
######################################################enable policy########
$policy = Get-AzRecoveryServicesBackupProtectionPolicy  -Name "EnhancedPolicy"
 
 
########enable VM######################################

Enable-AzRecoveryServicesBackupProtection -ResourceGroupName "$resourcegroup" -Name $vmName -Policy $policy
 
################Specify the container, obtain VM information, and run the backup#########
 
$backupcontainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -FriendlyName $vmName
 
$item = Get-AzRecoveryServicesBackupItem -Container $backupcontainer -WorkloadType "AzureVM"
 
Backup-AzRecoveryServicesBackupItem -Item $item
 
###########backup moniter#################################
$joblist = Get-AzRecoveryservicesBackupJob -VaultId $targetVaultID

$backupcontainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -FriendlyName $vmName -VaultId $targetVaultID

$backupItem = Get-AzRecoveryServicesBackupItem -Container $backupcontainer -WorkloadType AzureVM -VaultId $targetVaultID

Disable-AzRecoveryServicesBackupProtection -Item $backupItem -RemoveRecoveryPoints -VaultId $targetVaultID -Force
