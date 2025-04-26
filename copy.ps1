# Step 1: Paths
$VariablePath = "variable.json"
$AppSettingsPath = "appsettings.json"

# Step 2: Load JSONs
$variableJson = Get-Content $VariablePath -Raw | ConvertFrom-Json
$appSettingsJson = Get-Content $AppSettingsPath -Raw | ConvertFrom-Json

# Step 3: Ensure ConnectionStrings exists and is not null
if (-not $appSettingsJson.PSObject.Properties.Match('ConnectionStrings') -or $null -eq $appSettingsJson.ConnectionStrings) {
    $appSettingsJson | Add-Member -MemberType NoteProperty -Name 'ConnectionStrings' -Value $variableJson.ConnectionStrings
}



# Step 5: Save back to appsettings.json
$appSettingsJson | ConvertTo-Json -Depth 10 | Set-Content $AppSettingsPath
