configuration Exchange
{
    Import-DscResource -Name xIPAddress
    
    node $AllNodes.Where{($_.Role -eq "Exchange")}.NodeName
    {
        xIPAddress IP{
            InterfaceAlias = "Ethernet"
            IPAddress = $Node.IP
            SubnetMask = $Node.Subnet
        }

    }
}

Exchange -configurationData $PSSCriptRoot\ConfigData.psd1 -OutputPath $PSSCriptRoot\MOFS\