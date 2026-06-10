BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }

    # Get-ADUser comes from the ActiveDirectory RSAT module, which is only present on
    # domain-tooled Windows hosts; tests adapt to whether it is installed
    $HasActiveDirectory = [bool] (Get-Module -ListAvailable -Name 'ActiveDirectory')
}

Describe -Name 'Get-ADUserStatus' -Fixture {

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Get-ADUserStatus' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -Identity as mandatory' -Test {
            $script:Cmd.Parameters['Identity'].Attributes.Mandatory | Should -Contain $true
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an empty -Identity' -Test {
            { Get-ADUserStatus -Identity '' } | Should -Throw
        }
    }

    Context -Name 'ActiveDirectory module dependency' -Fixture {
        # The Begin block hard-imports ActiveDirectory with -ErrorAction Stop; on hosts without
        # RSAT this must surface as a terminating error instead of running with missing commands
        It -Name 'throws when the ActiveDirectory module is unavailable' -Skip:$HasActiveDirectory -Test {
            { Get-ADUserStatus -Identity 'jsmith' } | Should -Throw
        }
    }

    Context -Name 'user lookup (requires ActiveDirectory module)' -Fixture {
        # Get-ADUser is mocked so no domain controller is contacted; this only runs on hosts
        # where RSAT is installed because the mock target must resolve. Import-Module is also
        # mocked to keep the test hermetic. Note Get-ADUser types -Identity as [ADUser], so the
        # parameter filter must stringify the bound value before comparing.
        BeforeAll {
            if (Get-Module -ListAvailable -Name 'ActiveDirectory') {
                Mock -CommandName Import-Module -MockWith { } -ModuleName $env:BHProjectName
                Mock -CommandName Get-ADUser -MockWith {
                    [PSCustomObject] @{
                        CN                     = 'jsmith'
                        EmailAddress           = 'jsmith@example.com'
                        Created                = Get-Date '2020-01-01'
                        Enabled                = $true
                        LastLogonDate          = Get-Date '2026-06-01'
                        LockedOut              = $false
                        PasswordExpired        = $false
                        BadLogonCount          = 0
                        PasswordLastSet        = Get-Date '2026-05-01'
                    }
                } -ModuleName $env:BHProjectName
            }
        }

        It -Name 'queries the requested identity and selects the status property set' -Skip:(-not $HasActiveDirectory) -Test {
            $status = Get-ADUserStatus -Identity 'jsmith'
            Should -Invoke -CommandName Get-ADUser -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { "$Identity" -eq 'jsmith' }
            $status.CN        | Should -Be 'jsmith'
            $status.Enabled   | Should -BeTrue
            $status.LockedOut | Should -BeFalse
        }
    }
}
