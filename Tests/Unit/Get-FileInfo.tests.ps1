BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-FileInfo' -Fixture {

    Context -Name 'lookup against the bundled signature table' -Fixture {
        BeforeEach {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName
        }

        It -Name 'returns the matching signature record by hex prefix' -Test {
            $result = Get-FileInfo -Signature '89 50 4E 47'
            $result.Extension | Should -Contain 'png'
        }

        It -Name 'accepts -Signature via pipeline' -Test {
            $result = '25 50 44 46' | Get-FileInfo
            $result.Extension | Should -Contain 'pdf'
        }

        It -Name 'returns nothing for a signature that is not in the table' -Test {
            Get-FileInfo -Signature 'FF EE DD CC BB AA 99' | Should -BeNullOrEmpty
        }

        It -Name 'makes no network call' -Test {
            Get-FileInfo -Signature '89 50 4E 47' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
    }

    Context -Name 'session scope' -Fixture {
        It -Name 'does not create a global FileSignatures variable' -Test {
            $before = [bool] (Get-Variable -Name 'FileSignatures' -Scope Global -ErrorAction Ignore)
            Get-FileInfo -Signature '89 50 4E 47' | Out-Null
            [bool] (Get-Variable -Name 'FileSignatures' -Scope Global -ErrorAction Ignore) | Should -Be $before
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -Signature containing non-hex / non-space characters' -Test {
            { Get-FileInfo -Signature '50 4B !! 04' } | Should -Throw
        }

        It -Name 'rejects an empty -Signature' -Test {
            { Get-FileInfo -Signature '' } | Should -Throw
        }
    }
}
