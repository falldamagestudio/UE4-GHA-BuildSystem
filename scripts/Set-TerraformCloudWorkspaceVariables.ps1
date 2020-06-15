function Set-TerraformCloudWorkspaceVariables {

	param (
		[Parameter(Mandatory)] [string] $TerraformWorkspaceId,
		[Parameter(Mandatory)] [string] $TerraformAuthToken,
		[Parameter(Mandatory)] [PSCustomObject[]] $Variables
	)

    foreach ($Variable in $Variables) {

        Set-TerraformCloudWorkspaceVariable -TerraformWorkspaceId $TerraformWorkspaceId -TerraformAuthToken $TerraformAuthToken -Key $Variable.Key -Value $Variable.Value -Description $Variable.Description -Category $Variable.Category -Sensitive $Variable.Sensitive
    }
}