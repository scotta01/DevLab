param(
    $VMName,
    $VHD,
    $DSCPath,
    $DSCModules,
    $ProductKey = [string]$(Get-Content "$PSScriptRoot\Key.txt"),
    $Organization = "EiS",
    $Owner = "EiS DevOps",
    $TimeZone = "GMT Standard Time",
    $AdminPassword = "`$etup01",
    $UnattendTemplate="$PSScriptRoot\Unattend-template.xml"
     
)

Write-Host $VHD

$Unattendfile=New-Object XML
$Unattendfile.Load($UnattendTemplate)
$Unattendfile.unattend.settings.component[0].ComputerName=$VMName
$Unattendfile.unattend.settings.component[0].ProductKey=$ProductKey
$Unattendfile.unattend.settings.component[0].RegisteredOrganization=$Organization
$Unattendfile.unattend.settings.component[0].RegisteredOwner=$Owner
$Unattendfile.unattend.settings.component[0].TimeZone=$TimeZone
$Unattendfile.unattend.settings.Component[1].RegisteredOrganization=$Organization
$Unattendfile.unattend.settings.Component[1].RegisteredOwner=$Owner
$UnattendFile.unattend.settings.component[1].UserAccounts.AdministratorPassword.Value=$AdminPassword
$UnattendFile.unattend.settings.component[1].autologon.password.value=$AdminPassword

$UnattendXML="$PSScriptRoot\VMXmls\"+$VMName+".xml"
$Unattendfile.save($UnattendXML)


#
# Inject XML file into Virtual Machine
#


Mount-diskimage $VHD
$DriveLetter=((Get-DiskImage $VHD | get-disk | get-partition | ?{$_.Size -gt 500MB} ).DriveLetter)

$Destination="$($Driveletter):\Windows\System32\Sysprep\unattend.xml"
Copy-Item $UnattendXML $Destination

$DSCDestination = "$($Driveletter):\Sources\"
Copy-Item $DSCPath $DSCDestination

$DSCModulesDestination = "$($Driveletter):\Program Files\WindowsPowerShell\"
Copy-Item $DSCModules $DSCModulesDestination -Recurse -Force 

Dismount-diskimage $VHD

Remove-Item $UnattendXML

#All explorer to catch up
Start-Sleep -Seconds 2
