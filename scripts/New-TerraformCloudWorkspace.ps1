function New-TerraformCloudWorkspace {

	param (
		[Parameter(Mandatory)] [string] $GitHubOrganization,
		[Parameter(Mandatory)] [string] $GitHubRepository,
		[Parameter(Mandatory)] [string] $GitHubAuthTokenId,
	
		[Parameter(Mandatory)] [string] $TerraformOrganization,
		[Parameter(Mandatory)] [string] $TerraformAuthToken,
	
		[Parameter(Mandatory)] [string] $Workspace,
		[Parameter(Mandatory)] [string] $WorkingDirectory,
		[Parameter(Mandatory)] [string] $TerraformVersion
	
	)

	$VCSRepositoryIdentifier = "${GitHubOrganization}/${GitHubRepository}"

	$VCSRepo = @{
		# The VCS Connection (OAuth Connection + Token) to use. This ID can be obtained from the oauth-tokens endpoint.
		"oauth-token-id" = $GitHubAuthTokenId
		# Whether submodules should be fetched when cloning the VCS repository.
		"ingress-submodules" = $True
		# A reference to your VCS repository in the format :org/:repo where :org and :repo refer to the organization and repository in your VCS provider. The format for Azure DevOps is :org/:project/_git/:repo.
		identifier = $VCSRepositoryIdentifier
	}

	$RequestParameters = @{
		data = @{
			type = "workspaces"
			attributes = @{
				name = $Workspace
				"file-triggers-enabled" = $True.ToString().ToLower()
				"speculative-enabled" = $False.ToString().ToLower()
				"terraform-version" = $TerraformVersion
				"working-directory" = $WorkingDirectory
				"vcs-repo" = $VCSRepo
			}
		}
	}
	
	$RequestParametersJson = $RequestParameters | ConvertTo-Json -Depth 10

	$RequestParametersJson | Write-Host 

	$Result = Invoke-RestMethod -UseBasicParsing -Method Post -Uri "https://app.terraform.io/api/v2/organizations/${TerraformOrganization}/workspaces" -Body $RequestParametersJson -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"}

	return $Result.data.id
}