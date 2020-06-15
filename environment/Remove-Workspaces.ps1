param (
    [Parameter(Mandatory)] [string] $TerraformOrganization,
    [Parameter(Mandatory)] [string] $TerraformAuthToken,
    [Parameter(Mandatory)] [string] $GitHubRepository
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\..\..\scripts\Get-TerraformCloudWorkspaceId.ps1
. $here\..\..\scripts\Remove-TerraformCloudWorkspace.ps1

function RemoveWorkspace {

    param (
        [Parameter(Mandatory)] [string] $Terraservice
    )

    $WorkspacePrefix = "${TerraformOrganization}-${GitHubRepository}"
    $Workspace = "${WorkspacePrefix}-${Terraservice}"

    $TerraformWorkspaceId = Get-TerraformCloudWorkspaceId -TerraformOrganization $TerraformOrganization -TerraformAuthToken $TerraformAuthToken -Workspace $Workspace

    if ($null -ne $TerraformWorkspaceId) {
        $TerraformWorkspaceId = Remove-TerraformCloudWorkspace -TerraformWorkspaceId $TerraformWorkspaceId -TerraformAuthToken $TerraformAuthToken
    }
}

RemoveWorkspace -Terraservice "project"
RemoveWorkspace -Terraservice "storage"
RemoveWorkspace -Terraservice "builders"
