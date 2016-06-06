configuration Skype
{
    Import-DscResource -Name xIPAddress
    
    node $AllNodes.Where{($_.Role -eq "Skype")}.NodeName
    {
        xIPAddress IP{
            InterfaceAlias = "Ethernet"
            IPAddress = $Node.IP
            SubnetMask = $Node.Subnet
        }

    }
}

Skype -configurationData $PSSCriptRoot\ConfigData.psd1 -OutputPath $PSSCriptRoot\MOFS\