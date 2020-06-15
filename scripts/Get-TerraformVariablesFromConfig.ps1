function Get-TerraformVariablesFromConfig {

    param (
        [Parameter(Mandatory)] [string] $Folder
    )

    $Config = (& terraform-config-inspect "--json" $Folder) | ConvertFrom-Json

    return $Config.variables
}