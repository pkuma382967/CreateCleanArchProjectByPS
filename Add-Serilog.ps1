param (
    [string]$SolutionName
)

# Navigate to the API project directory
Set-Location -Path "$SolutionName.Api"

# Add Serilog NuGet packages
dotnet add package Serilog.AspNetCore
dotnet add package Serilog.Settings.Configuration
dotnet add package Serilog.Sinks.Console
dotnet add package Serilog.Sinks.File
dotnet add package Serilog.Sinks.Async
dotnet add package Serilog.Sinks.ContextRollingFile

# Copy the Serilog settings JSON file to the API project
$SerilogSettingsPath = "..\Add-serilog-setting.json"
$DestinationPath = "$SolutionName.Api\Add-serilog-setting.json"
Copy-Item -Path $SerilogSettingsPath -Destination $DestinationPath -Force

# Update Program.cs to configure Serilog
$ProgramFilePath = "$SolutionName.Api/Program.cs"
$ProgramContent = Get-Content -Path $ProgramFilePath

# Add Serilog configuration
$SerilogConfig = @"
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .CreateLogger();

builder.Host.UseSerilog();

// Add Serilog settings file to configuration
builder.Configuration.AddJsonFile("Add-serilog-setting.json", optional: true, reloadOnChange: true);
"@

# Insert Serilog configuration at the top of Program.cs
$UpdatedProgramContent = $SerilogConfig + "`n" + $ProgramContent
$UpdatedProgramContent | Set-Content -Path $ProgramFilePath

Write-Host "Serilog has been configured in Program.cs and settings file added." -ForegroundColor Green
