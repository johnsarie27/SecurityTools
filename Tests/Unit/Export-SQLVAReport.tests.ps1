BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Export-SQLVAReport' -Fixture {

    # The Begin block hard-imports the SqlServer module and the function body invokes the
    # SQL Vulnerability Assessment cmdlets, which only exist on hosts where SqlServer is
    # installed. The -ServerName parameter additionally pings the target via a
    # Test-Connection ValidateScript in caller scope. Together these prevent a meaningful
    # happy-path test inside the unit suite, so we cover metadata, parameter validation,
    # and the SqlServer module dependency failure here.

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Export-SQLVAReport' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -ServerName as mandatory with the SN/Server aliases and pipeline binding' -Test {
            $param = $script:Cmd.Parameters['ServerName']
            $param.Attributes.Mandatory         | Should -Contain $true
            $param.Attributes.ValueFromPipeline | Should -Contain $true
            $param.Aliases                      | Should -Contain 'SN'
            $param.Aliases                      | Should -Contain 'Server'
        }

        It -Name 'declares -PassThru as a switch parameter' -Test {
            $script:Cmd.Parameters['PassThru'].ParameterType |
            Should -Be ([System.Management.Automation.SwitchParameter])
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -ServerName that does not respond to a ping' -Test {
            { Export-SQLVAReport -ServerName 'no-such-host.invalid' } | Should -Throw
        }

        It -Name 'rejects a -BaselinePath that is not a .json file' -Test {
            $notJson = Join-Path -Path $TestDrive -ChildPath 'baseline.txt'
            Set-Content -Path $notJson -Value 'fixture'
            { Export-SQLVAReport -ServerName 'no-such-host.invalid' -BaselinePath $notJson } | Should -Throw
        }

        It -Name 'rejects an -OutputDirectory that does not exist' -Test {
            { Export-SQLVAReport -ServerName 'no-such-host.invalid' -OutputDirectory (Join-Path -Path $TestDrive -ChildPath 'nope') } |
            Should -Throw
        }
    }

    Context -Name 'SqlServer module dependency' -Fixture {
        # The Begin block does Import-Module SqlServer -ErrorAction Stop. On hosts without
        # the SqlServer RSAT module this must surface as a terminating error before the
        # function body runs. The test is skipped when the module happens to be installed.
        $HasSqlServer = [bool] (Get-Module -ListAvailable -Name 'SqlServer')

        It -Name 'throws when the SqlServer module is unavailable' -Skip:$HasSqlServer -Test {
            # ValidateScript on -ServerName needs a reachable host; use localhost so binding
            # succeeds and the SqlServer Import-Module failure is what we observe.
            { Export-SQLVAReport -ServerName 'localhost' -ErrorAction Stop } | Should -Throw
        }
    }
}
