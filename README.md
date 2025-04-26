# CreateCleanArchProjectByPS
Create Clean Arch Project by power shell script

step 1 : update variable json by project name and connection string
step 2 : Run Create-CleanArchProject.ps1 as administrator

help

Check Execution Policy
If the directory is correct but you still get an error, check the execution policy:
Get-ExecutionPolicy


If it says Restricted, you need to change it:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
This will allow scripts only for this session.


