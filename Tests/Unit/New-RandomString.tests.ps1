BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'New-RandomString' -Fixture {

    Context -Name 'default behavior' -Fixture {
        It -Name 'returns a string of the default length (8)' -Test {
            $s = New-RandomString
            $s | Should -BeOfType [System.String]
            $s.Length | Should -Be 8
        }

        It -Name 'returns a string of the requested -Length' -Test {
            (New-RandomString -Length 20).Length | Should -Be 20
        }

        It -Name 'returns a different string on each invocation (sanity check)' -Test {
            $a = New-RandomString -Length 32
            $b = New-RandomString -Length 32
            $a | Should -Not -Be $b
        }

        It -Name 'is exposed under the Get-RandomString alias' -Test {
            (Get-Command -Name Get-RandomString -ErrorAction Stop).ResolvedCommand.Name |
            Should -Be 'New-RandomString'
        }
    }

    Context -Name 'character-set exclusions' -Fixture {
        # Use generous length so that if a set were not actually excluded, at least one of those
        # characters would almost certainly appear (probability of false pass is negligible).
        BeforeAll {
            $script:Len = 200
        }

        It -Name '-ExcludeNumber produces a string with no digits' -Test {
            $s = New-RandomString -Length $script:Len -ExcludeNumber
            $s | Should -Not -Match '\d'
        }

        # Use -CMatch / -CNotMatch (case-sensitive) — default -Match is case-insensitive,
        # so [a-z] would also match A-Z and mask exclusion failures.
        It -Name '-ExcludeLowercase produces a string with no lowercase letters' -Test {
            $s = New-RandomString -Length $script:Len -ExcludeLowercase
            $s | Should -Not -CMatch '[a-z]'
        }

        It -Name '-ExcludeUppercase produces a string with no uppercase letters' -Test {
            $s = New-RandomString -Length $script:Len -ExcludeUppercase
            $s | Should -Not -CMatch '[A-Z]'
        }

        It -Name '-ExcludeSpecial produces a string with only alphanumerics' -Test {
            $s = New-RandomString -Length $script:Len -ExcludeSpecial
            $s | Should -CMatch '^[A-Za-z0-9]+$'
        }

        It -Name '-ExcludeCharacter removes the requested character from the output' -Test {
            $s = New-RandomString -Length $script:Len -ExcludeCharacter 'a'
            $s | Should -Not -CMatch 'a'
        }

        It -Name 'composes multiple exclusion flags' -Test {
            $s = New-RandomString -Length $script:Len -ExcludeNumber -ExcludeSpecial
            $s | Should -CMatch '^[A-Za-z]+$'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'errors when every character set is excluded' -Test {
            { New-RandomString -ExcludeNumber -ExcludeLowercase -ExcludeUppercase -ExcludeSpecial -ErrorAction Stop } |
            Should -Throw -ExpectedMessage '*at least one character set*'
        }
    }

    Context -Name 'edge-case lengths' -Fixture {
        It -Name 'returns a single character when -Length is 1' -Test {
            (New-RandomString -Length 1).Length | Should -Be 1
        }

        It -Name 'handles large lengths (1024 chars)' -Test {
            (New-RandomString -Length 1024).Length | Should -Be 1024
        }
    }
}
