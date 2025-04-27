# Load the JSON file
$jsonContent = Get-Content -Path "variable.json" | ConvertFrom-Json

# Access a nested value
$SolutionName = $jsonContent.SolutionName
$DefaultConnection = $jsonContent.ConnectionStrings
$ConnectionString = $jsonContent.ConnectionStrings.DefaultConnection
$IsSerilogEnabled = $jsonContent.IsSerilogEnabled

# Create the solution folder and navigate into it
New-Item -Path $SolutionName -ItemType Directory
Set-Location -Path $SolutionName

# Step 1: Create solution
dotnet new sln -n $SolutionName

# Step 2: Create Web API project
dotnet new webapi -n "$SolutionName.Api"
dotnet sln add "$SolutionName.Api/$SolutionName.Api.csproj"

# Step 3: Add Clean Architecture layers

# 3.1: Create Core layer (Domain)
dotnet new classlib -n "$SolutionName.Core"
dotnet sln add "$SolutionName.Core/$SolutionName.Core.csproj"

# 3.2: Create Application layer
dotnet new classlib -n "$SolutionName.Application"
dotnet sln add "$SolutionName.Application/$SolutionName.Application.csproj"

# 3.3: Create Infrastructure layer
dotnet new classlib -n "$SolutionName.Infrastructure"
dotnet sln add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj"

# 3.4: Create Persistence layer
dotnet new classlib -n "$SolutionName.Persistence"
dotnet sln add "$SolutionName.Persistence/$SolutionName.Persistence.csproj"

# Step 4: Add project references

# Application -> Core
dotnet add "$SolutionName.Application/$SolutionName.Application.csproj" reference "$SolutionName.Core/$SolutionName.Core.csproj"

# Infrastructure -> Application
dotnet add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj" reference "$SolutionName.Application/$SolutionName.Application.csproj"

# Persistence -> Core, Application
dotnet add "$SolutionName.Persistence/$SolutionName.Persistence.csproj" reference `
    "$SolutionName.Core/$SolutionName.Core.csproj", `
    "$SolutionName.Application/$SolutionName.Application.csproj"

# API -> Application, Infrastructure, Persistence
dotnet add "$SolutionName.Api/$SolutionName.Api.csproj" reference `
    "$SolutionName.Application/$SolutionName.Application.csproj", `
    "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj", `
    "$SolutionName.Persistence/$SolutionName.Persistence.csproj"

Write-Host "Clean Architecture base project created successfully!" -ForegroundColor Green

# Step 5: Update appsettings.json with the provided connection string
$AppSettingsPath = "$SolutionName.Api/appsettings.json"

# Read the appsettings.json
$jsonContent1 = Get-Content $AppSettingsPath -Raw | ConvertFrom-Json

Write-Host "Connection string updated in $DefaultConnection" -ForegroundColor Blue

# Step 6: Copy ConnectionStrings if missing
if (-not $jsonContent1.PSObject.Properties.Match('ConnectionStrings') -or $null -eq $jsonContent1.ConnectionStrings) {
    $jsonContent1 | Add-Member -MemberType NoteProperty -Name 'ConnectionStrings' -Value $DefaultConnection
}

# Write back to the file
$jsonContent1 | ConvertTo-Json -Depth 10 | Set-Content $AppSettingsPath

Write-Host "Connection string updated in appsettings.json" -ForegroundColor Green

# Step 7: Add Serilog if enabled
if ($IsSerilogEnabled -eq $true) {
    . .\Add-Serilog.ps1 -SolutionName $SolutionName
    Write-Host "Serilog has been added to the project." -ForegroundColor Green
}
