BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-WhoIs' -Fixture {

    BeforeAll {
        # Two-stage mock: the ARIN /ip/<addr> response, then the orgRef follow-up.
        $script:OrgRefUrl = 'http://whois.arin.net/rest/org/GOOGLE'

        # The orgRef property is serialized from XML, so it needs both a 'name' and a '#text' (the URL).
        $orgRef = New-Object -TypeName PSObject
        Add-Member -InputObject $orgRef -MemberType NoteProperty -Name 'name'  -Value 'Google LLC'
        Add-Member -InputObject $orgRef -MemberType NoteProperty -Name '#text' -Value $script:OrgRefUrl

        $script:IpResponse = [PSCustomObject] @{
            net = [PSCustomObject] @{
                name         = 'GOOGLE-NET'
                orgRef       = $orgRef
                startAddress = '8.8.8.0'
                endAddress   = '8.8.8.255'
                netBlocks    = [PSCustomObject] @{
                    netBlock = [PSCustomObject] @{ startaddress = '8.8.8.0'; cidrLength = '24' }
                }
                updateDate   = '2020-01-01'
            }
        }

        $script:OrgResponse = [PSCustomObject] @{
            org = [PSCustomObject] @{ city = 'Mountain View' }
        }

        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith { $script:IpResponse } `
            -ParameterFilter { $Uri -like 'http://whois.arin.net/rest/ip/*' }

        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith { $script:OrgResponse } `
            -ParameterFilter { $Uri -eq $script:OrgRefUrl }
    }

    Context -Name 'request shape' -Fixture {
        It -Name 'GETs the ARIN /ip/<addr> endpoint with Accept: application/xml' -Test {
            Get-WhoIs -IPAddress '8.8.8.8' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Uri -eq 'http://whois.arin.net/rest/ip/8.8.8.8' -and
                $Headers['Accept'] -eq 'application/xml'
            }
        }

        It -Name 'follows the orgRef URL to look up the city' -Test {
            Get-WhoIs -IPAddress '8.8.8.8' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq $script:OrgRefUrl }
        }
    }

    Context -Name 'response handling' -Fixture {
        It -Name 'projects the ARIN net record into a WhoIsResult object' -Test {
            $result = Get-WhoIs -IPAddress '8.8.8.8'
            $result.PSTypeNames                 | Should -Contain 'WhoIsResult'
            $result.IP.IPAddressToString        | Should -Be '8.8.8.8'
            $result.Name                        | Should -Be 'GOOGLE-NET'
            $result.RegisteredOrganization      | Should -Be 'Google LLC'
            $result.City                        | Should -Be 'Mountain View'
            $result.StartAddress                | Should -Be '8.8.8.0'
            $result.EndAddress                  | Should -Be '8.8.8.255'
            $result.NetBlocks                   | Should -Be '8.8.8.0/24'
            $result.Updated                     | Should -Be ([System.DateTime] '2020-01-01')
        }
    }
}
