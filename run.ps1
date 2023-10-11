function Get-RemoteChecksum {
	Param (
		[Parameter(Mandatory=$true)] [String] $URL,
		[Parameter()] [String] $Algorithm='sha512'
	)
	[String] $fn = [System.IO.Path]::GetTempFileName()
	Invoke-WebRequest $URL -OutFile $fn -UseBasicParsing
	[String] $res = Get-FileHash $fn -Algorithm $Algorithm | % Hash
	rm $fn -ea ignore
	return $res
}

# Get information about GitHub repository
[String] $repo = "sindresorhus/caprine"
[String] $url =  "https://api.github.com/repos/$repo/releases"
[String] $tag = "" # Custom tag here ("vX.Y.Z"), blank if newest
if ($tag -eq "") {$tag = (Invoke-WebRequest $url | ConvertFrom-Json)[0].tag_name}
[String] $download = "https://github.com/$repo/releases/download/$tag"

# Download latest.yml and extract information
[String] $fyml = "latest.yml"
[Object] $info = (Invoke-WebRequest "$download/$fyml" | ConvertFrom-Yaml)
[Version] $version = $info.version
[String] $fname = $info.path
[String] $pkg = $fname.split('-')[0] # assumes "Pkg-xxx.exe" format
[String] $lpkg = $pkg.toLower()
[String] $csum = Get-RemoteChecksum("$download/$fname") # latest.yml doesn't have a useful sha512...

# Update nuspec with version number
(Get-Content .\$pkg.nuspec.skel).replace('VERVERVER', $version) | Set-Content .\$pkg.nuspec

# Update tools/VERIFICATION.txt with checksum
(Get-Content .\tools\VERIFICATION.txt.skel).replace('NUMNUMNUM', $csum) | Set-Content .\tools\VERIFICATION.txt

# Update tools/chocolateyinstall.ps1 with filename and checksum
(Get-Content .\tools\chocolateyinstall.ps1.skel).replace('NUMNUMNUM', $csum).replace('VERVERVER', $version) | Set-Content .\tools\chocolateyinstall.ps1

# Package and push to Chocolatey
choco pack .\$pkg.nuspec
choco push .\$lpkg.$version.nupkg

# Clean up
rm .\$pkg.nuspec, .\tools\VERIFICATION.txt, .\tools\chocolateyinstall.ps1
