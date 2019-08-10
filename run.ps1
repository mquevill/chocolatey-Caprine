# Download newest version and get version number
$pkg = "Caprine"
$version = "2.35.0"
$fname = "$pkg.Setup.$version.exe"

#Update sgt-puzzles.nuspec with version number
(Get-Content .\$pkg.nuspec.skel).replace('VERVERVER', $version) | Set-Content .\$pkg.nuspec

#Update tools/VERIFICATION.txt with checksum
$csum = (checksum -t=sha512 .\tools\$fname)
(Get-Content .\tools\VERIFICATION.txt.skel).replace('NUMNUMNUM', $csum) | Set-Content .\tools\VERIFICATION.txt

#Update tools/chocolateyinstall.ps1 with filename and checksum
(Get-Content .\tools\chocolateyinstall.ps1.skel).replace('NUMNUMNUM', $csum).replace('FILEFILEFILE', $fname) | Set-Content .\tools\chocolateyinstall.ps1

#Package and push to Chocolatey
cpack $pkg.nuspec
cpush $pkg.$version.nupkg

#Clean up
rm Caprine.nuspec,tools\VERIFICATION.txt,tools\chocolateyinstall.ps1
