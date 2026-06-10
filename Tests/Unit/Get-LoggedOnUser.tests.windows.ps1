BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-LoggedOnUser' -Fixture {

    Context -Name 'local execution' -Fixture {
        # query.exe only exists on Windows. Invoke-Command is mocked so no real session opens.
        # Get-Module is mocked to return nothing so the function takes the plain "query user"
        # branch that does not depend on Microsoft.PowerShell.TextUtility.
        BeforeAll {
            $mockSessions = 'USERNAME  SESSIONNAME  ID  STATE'
            Mock -CommandName Get-Module -MockWith { $null } -ModuleName $env:BHProjectName
            Mock -CommandName Invoke-Command -MockWith { $mockSessions } -ModuleName $env:BHProjectName
        }

        # The -ComputerName ValidateScript pings the target before the body runs, so this can
        # only use localhost; localhost is in the function's self-reference list, which must
        # route to local execution rather than New-PSSession.
        It -Name 'treats localhost as the local system rather than opening a remote session' -Test {
            Get-LoggedOnUser -ComputerName 'localhost' | Should -Be 'USERNAME  SESSIONNAME  ID  STATE'
            Should -Invoke -CommandName Invoke-Command -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $null -eq $Session }
        }
    }
}
