BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-SavedHistory' -Fixture {

    BeforeAll {
        # Redirect the PSReadLine history lookup to a fixture file so results are deterministic
        $historyFile = Join-Path -Path $TestDrive -ChildPath 'history.txt'
        @(
            'Get-Process -Name pwsh'
            'Get-Service -Name BITS'
            'Get-Process -Name pwsh'
            'Get-Process -Id 42'
            '(Get-PSReadLineOption).HistorySavePath'
            'Get-SavedHistory -Search Get-Service'
        ) | Set-Content -Path $historyFile

        Mock -CommandName Get-PSReadLineOption -MockWith {
            [PSCustomObject] @{ HistorySavePath = $historyFile }
        } -ModuleName $env:BHProjectName
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'declares -Search as mandatory' -Test {
            (Get-Command -Name 'Get-SavedHistory').Parameters['Search'].Attributes.Mandatory |
                Should -Contain $true
        }

        It -Name 'rejects an empty search phrase' -Test {
            { Get-SavedHistory -Search '' } | Should -Throw
        }
    }

    Context -Name 'history search' -Fixture {
        It -Name 'returns commands matching the search phrase with duplicates removed' -Test {
            $result = Get-SavedHistory -Search 'Get-Process'
            $result             | Should -HaveCount 2
            $result.CommandLine | Should -Contain 'Get-Process -Name pwsh'
            $result.CommandLine | Should -Contain 'Get-Process -Id 42'
        }

        It -Name 'numbers results sequentially starting at 1' -Test {
            $result = Get-SavedHistory -Search 'Get-Process'
            $result.Id | Should -Be @(1, 2)
        }

        It -Name 'returns nothing when no command matches' -Test {
            Get-SavedHistory -Search 'Remove-VeryUnlikelyCommandName' | Should -BeNullOrEmpty
        }

        It -Name 'excludes history entries that reference HistorySavePath' -Test {
            Get-SavedHistory -Search 'PSReadLineOption' | Should -BeNullOrEmpty
        }

        It -Name 'excludes prior Get-SavedHistory invocations from results' -Test {
            Get-SavedHistory -Search 'Get-Service' | Should -HaveCount 1
        }
    }
}
