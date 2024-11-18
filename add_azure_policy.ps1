$rg1 = Get-AzResourceGroup -Name Netcon_resource_group
$i=0
$policy_name=@("0015ea4d-51ff-4ce3-8d8c-f3f8f0179a56", "058e9719-1ff9-3653-4230-23f76b6492e0", "12623e7e-4736-4b2e-b776-c1600f35f93a" ,"14b4e776-9fab-44b0-b53f-38d2458ea8be","4864134f-d306-4ff5-94d8-ea4553b18c97","86b3d65f-7626-441e-b690-81a8b71cff60","e1da06bd-25b6-4127-a301-c313d6873fff", "c8acafaf-3d23-44d1-9624-978ef0f8652c")

function add_policy{
$a = Get-AzPolicyDefinition -Name $policy_name[$i]
$policyparms = @{
Name = 'Audit'
DisplayName = 'VM managed policy'
Scope = $rg1.ResourceId
PolicyDefinition = $a
Description = 'Az PowerShell policy assignment to resource group'
}
}
for($i = 1 ; $i -le 8 ; $i++){
add_policy
}