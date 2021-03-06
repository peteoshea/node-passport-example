# Setup path variables
$binPath = Split-Path -Path $PSCommandPath -Parent
$scriptPath = Split-Path -Path $binPath -Parent
$basePath = Split-Path -Path $scriptPath -Parent

# There are multiple places to install a package so pull code into common function
function Install-ChocolateyPackage {
    param ([string]$Name)
    Write-Host "===> Installing '$Name'"
    choco upgrade $Name --confirm
}

# Install any required Chocolatey packages
$packagesFilePath = "$basePath\chocolatey-packages"
if (Test-Path -Path "$packagesFilePath" -PathType Leaf) {
    # Ensure Chocolatey is setup
    & "$binPath\installChocolatey.ps1"
    if ($LastExitCode) {
        Write-Host "Install/upgrade of Chocolatey failed with exit code: $LastExitCode"
        Exit $LastExitCode
    }

    Write-Host "`n==> Installing Chocolatey packages..."
    $packageList = Get-Content -Path "$packagesFilePath"
    if ($packageList.Count -eq 1) {
        # A single item is treated as a string not an array
        Install-ChocolateyPackage -Name $packageList
    }
    else {
        For ($index = 0; $index -lt $packageList.Count; $index++) {
            $package = $packageList[$index];
            Install-ChocolateyPackage -Name $package
        }
    }
    refreshenv
}

# Install any required winget packages
function Install-WinGetPackage {
    param ([string]$Name)
    Write-Host "===> Installing '$Name'"
    winget install $Name --exact
}

$packagesFilePath = "$basePath\winget-packages"
if (Test-Path -Path "$packagesFilePath" -PathType Leaf) {
    Write-Host "`n==> Installing winget packages..."
    $packageList = Get-Content -Path "$packagesFilePath"
    if ($packageList.Count -eq 1) {
        # A single item is treated as a string not an array
        Install-WinGetPackage -Name $packageList
    }
    else {
        For ($index = 0; $index -lt $packageList.Count; $index++) {
            $package = $packageList[$index];
            Install-WinGetPackage -Name $package
        }
    }
}

# If package.json file exists then ensure Node.js is setup and run `npm install`
$packageJson = "$basePath\package.json"
if (Test-Path -Path "$packageJson" -PathType Leaf) {
    # Setup appropriate version of Node.js from .nvmrc
    $nvmrc = "$basePath\.nvmrc"
    if (Test-Path -Path "$nvmrc" -PathType Leaf) {
        Write-Host "`n==> Installing appropriate version of Node.js..."
        $nodeVersion = Get-Content -Path "$nvmrc"
        nvm install $nodeVersion
        nvm use $nodeVersion
    }

    Write-Host "`n==> Installing npm dependencies..."
    Write-Host "Where is npm running from:"
    where.exe npm
    Write-Host "What version of npm:"
    npm -v
    Write-Host "Install npm packages..."
    npm install
}
