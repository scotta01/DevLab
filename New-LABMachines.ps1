param(
    $ParentPath = "D:\Machine templates\devtemplate.vhdx",
    $LABPath = "D:\Hyper-V\Virtual Hard Disks\Lab\",
    $LABswitch = "private", 
    $disksize = 127GB,
    $DSCConfigs = "$PSScriptRoot\DSC Configs",
    $DSCMOFS = "$PSScriptRoot\DSC Configs\MOFS",
    $DSCModules = "$PSScriptRoot\DSC Configs\Modules"
)

if(!(Test-Path $LABPath)){
    New-Item $LABPath -ItemType Directory -Force -Confirm:$false | Out-Null
}

if(!(Test-Path $ParentPath)){
    Copy-Item X:\Infrastructure\Alan\devtemplate.vhdx $ParentPath
}

if(!(Get-VMSwitch $LABswitch -ErrorAction SilentlyContinue)){
    New-VMSwitch -Name $LABSwitch -SwitchType Internal
}
#$machines = @(
#    [pscustomobject]@{
#        Name = "DEV-DC01"
#        RAM = 2GB
#    },
#    [pscustomobject]@{
#        Name = "DEV-S4B01"
#        RAM = 2GB
#    },
#    [pscustomobject]@{
#        Name = "DEV-EX01"
#        RAM = 2GB
#   },
#    [pscustomobject]@{
#        Name = "DEV-WEB01"
#        RAM = 2GB
#    }
#    
#)

Import-LocalizedData -BaseDirectory "$PSScriptRoot\DSC Configs" -FileName ConfigData.psd1 -BindingVariable machines

$AllDSCConfigs = ls $DSCConfigs *.ps1

foreach($DSCConfig in $AllDSCConfigs){
        & $DSCConfig.FullName
}


function New-Machine{
    param(
        $Name,
        $RAM,
        $vswitch,
        $VHDSize,
        $VHDTemplate,
        $path
    )
    $VHD = "{0}{1}.vhdx" -f $path, $Name
    New-VHD -ParentPath $VHDTemplate -Path $VHD -Differencing -SizeBytes $VHDSize
    New-VM -Name $Name -MemoryStartupBytes $RAM -VHDPath $VHD -SwitchName $vswitch
    Set-VM -Name $Name -ProcessorCount 2 -DynamicMemory
} 

foreach($machine in $machines.AllNodes){
    if($machine.NodeName -ne '*'){
        New-Machine -Name $machine.NodeName -RAM $machine.RAM -vswitch $LABswitch -VHDSize $disksize -VHDTemplate $ParentPath -path $LABPath 
        $VHD = Join-Path $LABPath "$($machine.NodeName).vhdx"
        $DSCFile = ls $DSCMOFS "$($machine.NodeName).mof"
        .$PSSCriptRoot\First-Run\Set-FirstRun.ps1 -VMName $machine.NodeName -VHD $VHD -DSCPath $DSCFile.FullName -DSCModules $DSCModules 
        
        Start-VM  $machine.NodeName
    }
    
    
}
