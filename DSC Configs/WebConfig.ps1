configuration Web
{
    Import-DscResource -Name xIPAddress
    
    node $AllNodes.Where{($_.Role -eq "Web")}.NodeName
    {
        xIPAddress IP{
            InterfaceAlias = "Ethernet"
            IPAddress = $Node.IP
            SubnetMask = $Node.Subnet
        }

    }
}

Web -configurationData $PSSCriptRoot\ConfigData.psd1 -OutputPath $PSSCriptRoot\MOFS\