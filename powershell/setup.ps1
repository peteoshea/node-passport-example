$scriptPath = Split-Path -Path $PSCommandPath -Parent
& "$scriptPath\bin\bootstrap.ps1"
if ($LastExitCode) {
    Write-Host "Bootstrap failed with exit code: $LastExitCode"
    Exit $LastExitCode
}

# Reset database to a fresh state
Write-Host "`n==> Setting up DB...`n"
dropdb testingpassport
createdb testingpassport

Write-Host "`n==> App is now ready to go!`n"
