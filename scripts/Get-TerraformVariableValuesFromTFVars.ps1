function Get-TerraformVariableValuesFromTFVars {

    param (
        [Parameter(Mandatory)] [string] $File
    )

    $KeysAndValues = Get-Content -Path $File -Raw | ConvertFrom-StringData

    $TrimmedKeysAndValues = @{}

    foreach ($Key in $KeysAndValues.Keys) {
        $TrimmedKeysAndValues[$Key] = $KeysAndValues[$Key].Trim('"')
    }

    return $TrimmedKeysAndValues
}