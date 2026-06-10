BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-ActiveGatewayUser' -Fixture {

    Context -Name 'connection listing' -Fixture {
        # The Begin-block platform guard means execution only happens on Windows. Get-CimInstance
        # is mocked, so neither the TerminalServices WMI namespace nor a real gateway is required.
        BeforeAll {
            Mock -CommandName Get-CimInstance -MockWith {
                [PSCustomObject] @{
                    UserName           = 'CONTOSO\jdoe'
                    ClientAddress      = '203.0.113.10'
                    ConnectedTime      = '20260610080000.000000-300'
                    ConnectionDuration = '00000000010203.000000:000'
                    ConnectedResource  = 'rdp-host-01'
                }
            } -ModuleName $env:BHProjectName
        }

        It -Name 'queries Win32_TSGatewayConnection in the TerminalServices namespace' -Test {
            Get-ActiveGatewayUser -ComputerName 'localhost' | Out-Null
            Should -Invoke -CommandName Get-CimInstance -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $ClassName -eq 'Win32_TSGatewayConnection' -and $Namespace -eq 'root\cimv2\TerminalServices' }
        }

        It -Name 'converts ConnectedTime and ConnectionDuration to readable values' -Test {
            $conn = Get-ActiveGatewayUser -ComputerName 'localhost'
            $conn.UserName          | Should -Be 'CONTOSO\jdoe'
            $conn.ClientAddress     | Should -Be '203.0.113.10'
            $conn.ConnectionTime    | Should -Be (Get-Date -Date '2026-06-10 08:00:00')
            $conn.ElapsedTime       | Should -Be '01:02:03'
            $conn.ConnectedResource | Should -Be 'rdp-host-01'
        }
    }
}
