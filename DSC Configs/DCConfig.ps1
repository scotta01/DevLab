configuration DomainControllers
{
    Import-DscResource -Name xIPAddress
    
    node $AllNodes.Where{($_.Role -eq "DomainController")}.NodeName
    {
        xIPAddress IP{
            InterfaceAlias = "Ethernet"
            IPAddress = $Node.IP
            SubnetMask = $Node.Subnet
        }

    }
}

DomainControllers -configurationData $PSSCriptRoot\ConfigData.psd1 -OutputPath $PSSCriptRoot\MOFS\ 