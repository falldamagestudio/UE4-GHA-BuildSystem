function Get-TerraformCloudWorkspaceId {

    param (
        [Parameter(Mandatory)] [string] $TerraformOrganization,
		[Parameter(Mandatory)] [string] $TerraformAuthToken,
        [Parameter(Mandatory)] [string] $Workspace
    )

    $GetWorkspacesResponse = Invoke-RestMethod -UseBasicParsing -Uri "https://app.terraform.io/api/v2/organizations/${TerraformOrganization}/workspaces" -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"}

    foreach ($WorkspaceDescriptor in $GetWorkspacesResponse.data) {

        if ($WorkspaceDescriptor.attributes.name -eq $Workspace) {

            return $WorkspaceDescriptor.id
        }
    }

    Write-Error "Workspace ${Workspace} not found in Terraform organization ${TerraformOrganization}"

    return $null
}