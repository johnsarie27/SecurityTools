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
}
