param (
    [Parameter(Mandatory)] [string] $TerraformOrganization,
    [Parameter(Mandatory)] [string] $TerraformAuthToken,
    [Parameter(Mandatory)] [string] $VCSProvider,
    [Parameter(Mandatory)] [string] $GitHubOrganization,
    [Parameter(Mandatory)] [string] $GitHubRepository
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\..\scripts\Get-VCSProviderAuthTokenId.ps1
. $here\..\scripts\Get-TerraformVariableValuesFromTFVars.ps1
. $here\..\scripts\Get-TerraformVariablesFromConfig.ps1
. $here\..\scripts\New-TerraformCloudWorkspace.ps1
. $here\..\scripts\Set-TerraformCloudWorkspaceVariable.ps1
. $here\..\scripts\Set-TerraformCloudWorkspaceVariables.ps1

function SetupWorkspace {

    param (
        [Parameter(Mandatory)] [string] $Terraservice
    )

    $WorkspacePrefix = "${TerraformOrganization}-${GitHubRepository}"
    $Workspace = "${WorkspacePrefix}-${Terraservice}"

    $TerraformWorkspaceId = Get-TerraformCloudWorkspaceId -TerraformOrganization $TerraformOrganization -TerraformAuthToken $TerraformAuthToken -Workspace $Workspace

    if ($null -eq $TerraformWorkspaceId) {
        $TerraformWorkspaceId = New-TerraformCloudWorkspace -GitHubOrganization $GitHubOrganization -GitHubRepository $GitHubRepository -GitHubAuthTokenId $GitHubAuthTokenId -TerraformOrganization $TerraformOrganization -TerraformAuthToken $TerraformAuthToken -Workspace $Workspace -WorkingDirectory "${WorkingDirectoryBase}/${Terraservice}" -TerraformVersion $TerraformVersion
    }
    
    if ($null -ne $TerraformWorkspaceId) {

        $ConfigVariables = Get-TerraformVariablesFromConfig -Folder $here\$Terraservice

        $VariableValues = Get-TerraformVariableValuesFromTFVars -File "${Terraservice}\terraform.tfvars"

        foreach ($ConfigVariableProperty in $ConfigVariables.PSObject.Properties) {

            $ConfigVariableName = $ConfigVariableProperty.name
            $ConfigVariable = $ConfigVariables.$ConfigVariableName

            $Key = $ConfigVariableName
            $Value = $VariableValues[$Key]
            $Description = if ($null -ne $ConfigVariable.description) { $ConfigVariable.description } else { $null }
            $Sensitive = $Description -like "*(sensitive)"

            $Variables += @(@{
                Key = $Key
                Value = $Value
                Description = $Description
                Category = "terraform"
                Sensitive = $Sensitive
            })
        }

        $Variables += @(@{
            Key = "GOOGLE_CREDENTIALS"
            Value = ((Get-Content -Path "application-default-credentials.json" -Raw) -Replace "`n","")
            Description = "Credentials for Google Cloud provider"
            Category = "env"
            Sensitive = $True
        })

        Set-TerraformCloudWorkspaceVariables -TerraformWorkspaceId $TerraformWorkspaceId -TerraformAuthToken $TerraformAuthToken -Variables $Variables
    }
}

$GitHubAuthTokenId = Get-VCSProviderAuthTokenId -TerraformOrganization $TerraformOrganization -TerraformAuthToken $TerraformAuthToken -VCSProvider $VCSProvider

$WorkingDirectoryBase = "environment"
$TerraformVersion = "0.12.26"

SetupWorkspace -Terraservice "project"
SetupWorkspace -Terraservice "storage"
SetupWorkspace -Terraservice "builders"
