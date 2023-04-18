# Chocolatey-Caprine
Source files of [Chocolatey package for Caprine](https://community.chocolatey.org/packages/caprine)

Automatically downloads the newest version of Caprine,
packages it into a Chocolatey package,
and pushes it to the Chocolatey website.

To build and push the package, simply run `run.ps1`:
```powershell
.\run.ps1
```

_NOTE:_ Requires [powershell-yaml](https://github.com/cloudbase/powershell-yaml) module:
from the [PowerShell Gallery](https://www.powershellgallery.com/)
```powershell
Install-Module powershell-yaml
```

This script will:
- download the newest build information
- pack the .nupkg
- push to Chocolatey
- clean up build files
