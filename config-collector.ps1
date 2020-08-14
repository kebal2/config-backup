$configPath = "configs"

$configPathExists = (Test-Path $configPath)

if ($configPathExists -eq $false) {
    New-Item Configs -ItemType Directory
}

$files = Get-Childitem -Path . -Include "appsettings.Development.json" -Recurse | where-object { $_.fullname -notmatch ".*netcoreapp2.*" }

$files | ForEach-Object {

    $settingsFile = $_

    $destinationPath = Join-Path -Path $configPath (Resolve-Path (Split-Path -Path $settingsFile.FullName) -Relative)

    if ((Test-Path $destinationPath) -eq $false) {
        Write-Output $destinationPath

        New-Item $destinationPath -ItemType Directory
    }

    #Copy-Item
    Copy-Item $settingsFile -Destination $destinationPath
}

Compress-Archive -Path $configPath -DestinationPath "$configPath.zip"

Remove-Item -Path $configPath -Recurse -Confirm:$false -Force