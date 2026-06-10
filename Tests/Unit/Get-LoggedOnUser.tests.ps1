BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-LoggedOnUser' -Fixture {

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Get-LoggedOnUser' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -ComputerName as optional with the CN alias' -Test {
            $param = $script:Cmd.Parameters['ComputerName']
            $param.Attributes.Mandatory | Should -Not -Contain $true
            $param.Aliases              | Should -Contain 'CN'
        }
    }

    Context -Name 'local execution' -Fixture {
        # query.exe only exists on Windows and the remote branch needs a reachable PSSession,
        # so both session-listing calls are mocked. Get-Module is mocked to return nothing so
        # the function takes the plain "query user" branch that does not depend on
        # Microsoft.PowerShell.TextUtility.
        BeforeAll {
            $mockSessions = 'USERNAME  SESSIONNAME  ID  STATE'
            Mock -CommandName Get-Module -MockWith { $null } -ModuleName $env:BHProjectName
            Mock -CommandName Invoke-Command -MockWith { $mockSessions } -ModuleName $env:BHProjectName
        }

        It -Name 'runs the query locally when no ComputerName is provided' -Test {
            Get-LoggedOnUser | Should -Be 'USERNAME  SESSIONNAME  ID  STATE'
            Should -Invoke -CommandName Invoke-Command -ModuleName $env:BHProjectName -Times 1 -Exactly
        }

        # The -ComputerName ValidateScript pings the target before the body runs, so this can
        # only use localhost; localhost is in the function's self-reference list, which must
        # route to local execution rather than New-PSSession.
        It -Name 'treats localhost as the local system rather than opening a remote session' -Skip:(-not $IsWindows) -Test {
            Get-LoggedOnUser -ComputerName 'localhost' | Should -Be 'USERNAME  SESSIONNAME  ID  STATE'
            Should -Invoke -CommandName Invoke-Command -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $null -eq $Session }
        }
    }
}
