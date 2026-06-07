BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-Weather' -Fixture {

    BeforeAll {
        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith { 'weather report' }
    }

    Context -Name 'URL construction' -Fixture {
        It -Name 'GETs the wttr.in root when no parameters are provided' -Test {
            Get-Weather | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://wttr.in/' }
        }

        It -Name 'appends the city when -City is provided' -Test {
            Get-Weather -City 'Seattle' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://wttr.in/Seattle' }
        }

        It -Name 'replaces spaces in -City with + characters' -Test {
            Get-Weather -City 'New York' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://wttr.in/New+York' }
        }

        It -Name 'appends ?format=<n> when -Format is a numeric preset' -Test {
            Get-Weather -City 'Seattle' -Format 3 | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'https://wttr.in/Seattle?format=3' }
        }

        It -Name 'appends the sun format string when -Format is Sun' -Test {
            Get-Weather -City 'Seattle' -Format 'Sun' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                    $u = $Uri.OriginalString
                    $u.StartsWith('https://wttr.in/Seattle?format=') -and $u.Contains('%l')
                }
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -Format value outside the validated set' -Test {
            { Get-Weather -Format 9 } | Should -Throw
        }

        It -Name 'rejects an empty -City' -Test {
            { Get-Weather -City '' } | Should -Throw
        }
    }
}
