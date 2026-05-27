<#

This script adds the permissions required for this demo to work.
You need to run this script for each of the two Logic Apps deployed with the ARM template, 
using the Object (principal) ID of each Logic App's managed identity as the `IdentityPrincipalId` parameter value.

Requires the Azure CLI to be installed and logged in with an account that has permissions to manage app role assignments.

Most convenient way to run this script is from the Azure Cloud Shell, which has the Azure CLI pre-installed and logged in.

Author: Henri Perämäki (henri.peramaki@elisa.fi)

#>
param (
    [string]$IdentityPrincipalId
)

$GraphAppId = "00000003-0000-0000-c000-000000000000"

$GraphAPISP = az ad sp show --id $GraphAppId | ConvertFrom-JSON
$GraphAPIAppRoles = $GraphAPISP.AppRoles
$GraphObjectID = $GraphAPISP.id

$PermissionNames = "DeviceManagementConfiguration.Read.All"

Write-Host "Adding required Application Role assignments..."

Foreach ($PermissionName in $PermissionNames) {
    Write-Host "  Application role: $PermissionName"
    Write-Host "  Managed Identity: $IdentityPrincipalId"
    Write-Host
    $AppRole = $null
    $AppRole = $GraphAPIAppRoles | Where-Object {$_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application"}
    If ($AppRole) {
        $RestBody = $null
        $RestBody = (@{
            principalId = $IdentityPrincipalId
            resourceId = $GraphObjectID 
            appRoleId = $AppRole.id
         } | ConvertTo-JSON -Compress)
        az rest -m POST -u "https://graph.microsoft.com/v1.0/servicePrincipals/$($IdentityPrincipalId)/appRoleAssignedTo" -b $RestBody --headers Content-Type=application/json
    } else {
        Write-Error "Unknown app role $PermissionName"
    }
}

Write-Host 
Write-Host "Done."