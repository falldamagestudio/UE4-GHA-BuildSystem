function Set-TerraformCloudWorkspaceVariable {

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

    $RequestParametersJson = $RequestParameters | ConvertTo-Json -Depth 10

    $ExistingVariables = Invoke-RestMethod -UseBasicParsing -Method Get -Uri "https://app.terraform.io/api/v2/workspaces/${TerraformWorkspaceId}/vars" -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"}

    $ExistingVariable = $ExistingVariables.data | Where-Object { $_.attributes.key -eq $Key }

    if ($null -ne $ExistingVariable) {

        $VariableId = $ExistingVariable.id

        $RequestParameters = @{
            data = @{
                type = "vars"
                id = $VariableId
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

        Invoke-RestMethod -UseBasicParsing -Method Patch -Uri "https://app.terraform.io/api/v2/workspaces/${TerraformWorkspaceId}/vars/${VariableId}" -Body $RequestParametersJson -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"} | Out-Null

    } else {

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

        Invoke-RestMethod -UseBasicParsing -Method Post -Uri "https://app.terraform.io/api/v2/workspaces/${TerraformWorkspaceId}/vars" -Body $RequestParametersJson -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"} | Out-Null
    }
}