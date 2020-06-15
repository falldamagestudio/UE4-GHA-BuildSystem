param (
    [Parameter(Mandatory)] [string] $TerraformOrganization,
    [Parameter(Mandatory)] [string] $GitHubRepository
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\..\..\scripts\Get-TerraformVariablesFromConfig.ps1

function CreateTFVarsFile {

    param (
        [Parameter(Mandatory)] [string] $Terraservice
    )

    $WorkspacePrefix = "${TerraformOrganization}-${GitHubRepository}"

    $ConfigVariables = Get-TerraformVariablesFromConfig -Folder $here\$Terraservice

    $VariableValues = @{
        terraform_cloud_organization = $TerraformOrganization
        terraform_cloud_workspace_prefix = $WorkspacePrefix
    }

    $Content = ""

    foreach ($ConfigVariableProperty in $ConfigVariables.PSObject.Properties) {

        $ConfigVariableName = $ConfigVariableProperty.name
        $ConfigVariable = $ConfigVariables.$ConfigVariableName

        $Key = $ConfigVariableName
        $Value = if ($null -ne $VariableValues[$Key]) { $VariableValues[$Key] } elseif ($null -ne $ConfigVariable.default) { $ConfigVariable.default } else { "" }

        $Content += "${Key} = ""${Value}""`n"
    }

    $Content | Set-Content -Path "${Terraservice}\terraform.tfvars"
}

CreateTFVarsFile -Terraservice "project"
CreateTFVarsFile -Terraservice "storage"
CreateTFVarsFile -Terraservice "builders"
