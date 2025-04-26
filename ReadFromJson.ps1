# Load the JSON file
$jsonContent = Get-Content -Path "variable.json" | ConvertFrom-Json

# Access a nested value
$solutionName = $jsonContent.SolutionName
$connectionString = $jsonContent.ConnectionStrings.DefaultConnection

# Output the value
Write-Host "Connection String: $connectionString"
Write-Host "Connection String: $solutionName"
