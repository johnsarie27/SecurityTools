BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-FileInfo' -Fixture {

    BeforeAll {
        $script:FakeSignatures = @(
            [PSCustomObject] @{ Hex_signature = '50 4B 03 04'; ISO_8859_1 = 'PK..'; File_extension = '.zip,.docx,.xlsx'; Description = 'ZIP archive' }
            [PSCustomObject] @{ Hex_signature = '89 50 4E 47'; ISO_8859_1 = '.PNG';  File_extension = '.png';            Description = 'PNG image' }
            [PSCustomObject] @{ Hex_signature = '25 50 44 46'; ISO_8859_1 = '%PDF';  File_extension = '.pdf';            Description = 'PDF document' }
        )

        # The function caches the signature table in a Global variable. Save and restore the existing
        # value so we don't clobber an in-session cache or leak test state.
        $script:HadGlobalCache  = $null -ne (Get-Variable -Name 'FileSignatures' -Scope Global -ErrorAction Ignore)
        $script:OriginalCache   = if ($script:HadGlobalCache) { $Global:FileSignatures } else { $null }
    }

    AfterAll {
        # Restore prior state
        Remove-Variable -Name 'FileSignatures' -Scope Global -Force -ErrorAction Ignore
        if ($script:HadGlobalCache) {
            New-Variable -Name 'FileSignatures' -Scope Global -Value $script:OriginalCache
        }
    }

    Context -Name 'happy path with pre-warmed cache' -Fixture {
        BeforeEach {
            # Pre-populate the Global cache so the function does not call Invoke-RestMethod.
            Remove-Variable -Name 'FileSignatures' -Scope Global -Force -ErrorAction Ignore
            New-Variable -Name 'FileSignatures' -Scope Global -Value $script:FakeSignatures
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName
        }

        It -Name 'returns the matching signature record by hex prefix' -Test {
            $result = Get-FileInfo -Signature '50 4B 03 04'
            $result.File_extension | Should -Be '.zip,.docx,.xlsx'
            $result.Description    | Should -Be 'ZIP archive'
        }

        It -Name 'does not call Invoke-RestMethod when the Global cache is populated' -Test {
            Get-FileInfo -Signature '50 4B 03 04' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }

        It -Name 'accepts -Signature via pipeline' -Test {
            $result = '25 50 44 46' | Get-FileInfo
            $result.Description | Should -Be 'PDF document'
        }
    }

    Context -Name 'cache-miss path' -Fixture {
        BeforeEach {
            # Clear cache so the function fetches the signature table.
            Remove-Variable -Name 'FileSignatures' -Scope Global -Force -ErrorAction Ignore
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith { $script:FakeSignatures }
        }

        It -Name 'GETs the signatures gist when the cache is empty' -Test {
            Get-FileInfo -Signature '89 50 4E 47' | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly `
                -ParameterFilter { $Uri -like 'https://gist.githubusercontent.com/*/FileSignatures.json' }
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
