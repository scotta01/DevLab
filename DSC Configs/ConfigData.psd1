@{
   AllNodes = @(        
       @{
            NodeName = "*"
            Subnet = 24
        },
        @{
            NodeName = "DEV-DC01"
            Role = "DomainController"
            IP = "192.168.250.1"
            RAM = 2GB
        },
        @{
            NodeName = "DEV-EX01"
            Role = "Exchange"
            IP = "192.168.250.10"
            RAM = 2GB
        },
        @{
            NodeName = "DEV-S4B01"
            Role = "Skype"
            IP = "192.168.250.20"
            RAM = 2GB
        },
        @{
            NodeName = "DEV-WEB01"
            Role = "Web"
            IP = "192.168.250.30"
            RAM = 2GB
        }

    )
}