BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-ActiveGatewayUser' -Fixture {

    # The function's -ComputerName parameter has a [ValidateScript({ Test-Connection ... })] guard
    # that fires before the function body runs, so invoking it requires a reachable target; the
    # execution tests below use localhost (always answers) with Get-CimInstance mocked so no real
    # RDG host is needed.

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Get-ActiveGatewayUser' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'exposes the Get-ActiveGWUser alias' -Test {
            $alias = Get-Alias -Name 'Get-ActiveGWUser' -ErrorAction Ignore
            $alias.ResolvedCommandName | Should -Be 'Get-ActiveGatewayUser'
        }

        It -Name 'declares -ComputerName as mandatory with Name/CN/Computer/System/Target aliases' -Test {
            $param = $script:Cmd.Parameters['ComputerName']
            $param.Attributes.Mandatory                | Should -Contain $true
            $param.Aliases                             | Should -Contain 'Name'
            $param.Aliases                             | Should -Contain 'CN'
            $param.Aliases                             | Should -Contain 'Computer'
            $param.Aliases                             | Should -Contain 'System'
            $param.Aliases                             | Should -Contain 'Target'
        }
    }

    Context -Name 'connection listing (Windows only)' -Fixture {
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

        It -Name 'queries Win32_TSGatewayConnection in the TerminalServices namespace' -Skip:(-not $IsWindows) -Test {
            Get-ActiveGatewayUser -ComputerName 'localhost' | Out-Null
            Should -Invoke -CommandName Get-CimInstance -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $ClassName -eq 'Win32_TSGatewayConnection' -and $Namespace -eq 'root\cimv2\TerminalServices' }
        }

        It -Name 'converts ConnectedTime and ConnectionDuration to readable values' -Skip:(-not $IsWindows) -Test {
            $conn = Get-ActiveGatewayUser -ComputerName 'localhost'
            $conn.UserName          | Should -Be 'CONTOSO\jdoe'
            $conn.ClientAddress     | Should -Be '203.0.113.10'
            $conn.ConnectionTime    | Should -Be (Get-Date -Date '2026-06-10 08:00:00')
            $conn.ElapsedTime       | Should -Be '01:02:03'
            $conn.ConnectedResource | Should -Be 'rdp-host-01'
        }
    }
}
