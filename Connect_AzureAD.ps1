Try
{

#param([parameter(mandatory=$true)][string]$user,[parameter(mandatory=$true)][string]$user_mobile,[parameter(mandatory=$true)][string]$user_surname)


$user="soumya.a@netcon.in"
$user_mobile="8147990201"
$user_surname="Patar"
Import-Module AZureAD
$username1='netdevopsid@netcon.in'
$password1 = 'D3v0ps@321'
$pass1=$password1 |ConvertTo-SecureString -AsPlainText -Force
$Creds = New-Object  System.Management.Automation.PsCredential($username1,$pass1)
$connect=Connect-AzureAD -Credential $Creds
$user_found=Get-AzureADUser -ObjectID $user | Select  DisplayName,UserPrincipalName,AccountEnabled
$activity=$user_found.AccountEnabled
$dep = Get-AzureADUser -ObjectID $user | Select Department
$mobile=Get-AzureADUser -ObjectID $user | Select mobile
$surname=Get-AzureADUser -ObjectID $user | Select Surname
$department = ($dep).department
$department

if($activity -eq "True"){

if(($mobile -match "8147990201") -and ($surname -match "Pattar")){
echo "True"
}
else
{
echo "Username details are incorrect"
}

}
else
{
echo "User $user is not available in the Azure AD, hence reassigning."
}
Disconnect-AzAccount
}
catch
{
#echo "User $user is not available in the Azure AD"
Write-Host $_.Exception.Message
}