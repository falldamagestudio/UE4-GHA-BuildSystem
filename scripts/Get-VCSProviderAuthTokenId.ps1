function Get-VCSProviderAuthTokenId {

    param (
        [Parameter(Mandatory)] [string] $TerraformOrganization,
		[Parameter(Mandatory)] [string] $TerraformAuthToken,
        [Parameter(Mandatory)] [string] $VCSProvider
    )

    $GetOAuthClientsResponse = Invoke-RestMethod -UseBasicParsing -Uri "https://app.terraform.io/api/v2/organizations/${TerraformOrganization}/oauth-clients" -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"}

    foreach ($OAuthClient in $GetOAuthClientsResponse.data) {

        if ($OAuthClient.name -eq $GitHubDescription) {
            $OAuthClientId = $OAuthClient.id

            $GetOAuthTokensResponse = Invoke-RestMethod -UseBasicParsing -Uri "https://app.terraform.io/api/v2/oauth-clients/${OAuthClientId}/oauth-tokens" -ContentType "application/vnd.api+json" -Headers @{ "Authorization" = "Bearer ${TerraformAuthToken}"}

            return $GetOAuthTokensResponse.data.id
        }
    }

    Write-Error "VCS provider ${VCSProvider} not found among registered VCS providers in Terraform organization ${TerraformOrganization}"

    return $null
}