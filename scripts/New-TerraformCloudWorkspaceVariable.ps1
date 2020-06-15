function New-TerraformCloudWorkspaceVariable {

	param (
		[Parameter(Mandatory)] [string] $TerraformWorkspaceId,
		[Parameter(Mandatory)] [string] $TerraformAuthToken,
		[Parameter(Mandatory)] [string] $Key,
		[Parameter(Mandatory)] [string] $Value,
		[Parameter(Mandatory=$False)] [string] $Description = $null,
		[Parameter(Mandatory=$False)] [string] $Category = "terraform",
		[Parameter(Mandatory=$False)] [string] $HCL = $False,
		[Parameter(Mandatory=$False)] [string] $Sensitive = $False
	)

    $RequestParameters = @{
        data = @{
            type = "vars"
            attributes = @{
                key = $Key
                value = $Value
                description = $Description
                category = $Category
                hcl = $HCL.ToString().ToLower()
                sensitive = $Sensitive.ToString().ToLower()
            }
        }
    }
    
    $RequestParametersJson = $RequestParameters | ConvertTo-Json -Depth 10

    Invoke-RestMethod -UseBasicParsing -Method Post -Uri "https://app.terraform.io/api/v2/workspaces/${TerraformWorkspaceId}/vars" -Body $RequestParametersJson -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"}
}