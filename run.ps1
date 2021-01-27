# Download newest version and get version number
$pkg = "Caprine"
$lpkg = "$pkg".toLower()
$version = "2.52.0"
$fname = "$pkg-Setup-$version.exe"

#Update nuspec with version number
(Get-Content .\$pkg.nuspec.skel).replace('VERVERVER', $version) | Set-Content .\$pkg.nuspec

#Update tools/VERIFICATION.txt with checksum
$csum = (checksum -t=sha512 .\$fname)
(Get-Content .\tools\VERIFICATION.txt.skel).replace('NUMNUMNUM', $csum) | Set-Content .\tools\VERIFICATION.txt

#Update tools/chocolateyinstall.ps1 with filename and checksum
(Get-Content .\tools\chocolateyinstall.ps1.skel).replace('NUMNUMNUM', $csum).replace('VERVERVER', $version) | Set-Content .\tools\chocolateyinstall.ps1

#Package and push to Chocolatey
cpack .\$pkg.nuspec
cpush .\$lpkg.$version.nupkg

#Clean up
rm .\$pkg.nuspec, .\tools\VERIFICATION.txt, .\tools\chocolateyinstall.ps1
