# Get information from GitHub repository
[String] $repo = "sindresorhus/caprine"
[String] $url =  "https://api.github.com/repos/$repo/releases"
[String] $tag = (Invoke-WebRequest $url | ConvertFrom-Json)[0].tag_name
[Version] $version = $tag -replace 'v','' # assumes "vX.Y.Z" format
[String] $download = "https://github.com/$repo/releases/download/$tag"

# Download latest.yml and extract information
[String] $fyml = "latest.yml"
[Object] $info = (Invoke-WebRequest "$download/$fyml" | ConvertFrom-Yaml)
[String] $fname = $info.path
[String] $pkg = $fname.split('-')[0] # assumes "Pkg-xxx.exe" format
[String] $lpkg = $pkg.toLower()
[String] $csum = $info.sha512

# Update nuspec with version number
(Get-Content .\$pkg.nuspec.skel).replace('VERVERVER', $version) | Set-Content .\$pkg.nuspec

# Update tools/VERIFICATION.txt with checksum
(Get-Content .\tools\VERIFICATION.txt.skel).replace('NUMNUMNUM', $csum) | Set-Content .\tools\VERIFICATION.txt

# Update tools/chocolateyinstall.ps1 with filename and checksum
(Get-Content .\tools\chocolateyinstall.ps1.skel).replace('NUMNUMNUM', $csum).replace('VERVERVER', $version) | Set-Content .\tools\chocolateyinstall.ps1

# Package and push to Chocolatey
cpack .\$pkg.nuspec
cpush .\$lpkg.$version.nupkg

# Clean up
rm .\$pkg.nuspec, .\tools\VERIFICATION.txt, .\tools\chocolateyinstall.ps1
