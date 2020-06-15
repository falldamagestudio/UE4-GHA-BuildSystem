function Remove-TerraformCloudWorkspace {

    param (
		[Parameter(Mandatory)] [string] $TerraformWorkspaceId,
		[Parameter(Mandatory)] [string] $TerraformAuthToken
    )
    
    Invoke-RestMethod -UseBasicParsing -Method Delete -Uri "https://app.terraform.io/api/v2/workspaces/${TerraformWorkspaceId}" -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"} | Out-Null
}