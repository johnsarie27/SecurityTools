BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-StringHash' -Fixture {

    # Reference values computed from the canonical algorithms over UTF-8 bytes.
    # These are stable and let us assert exact hash output (not just shape).
    BeforeAll {
        $script:Cases = @(
            @{ Algorithm = 'MD5'   ; Input = ''      ; Expected = 'd41d8cd98f00b204e9800998ecf8427e' }
            @{ Algorithm = 'SHA1'  ; Input = ''      ; Expected = 'da39a3ee5e6b4b0d3255bfef95601890afd80709' }
            @{ Algorithm = 'SHA256'; Input = ''      ; Expected = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' }
            @{ Algorithm = 'SHA256'; Input = 'abc'   ; Expected = 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad' }
            @{ Algorithm = 'SHA512'; Input = 'abc'   ; Expected = 'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f' }
        )
    }

    Context -Name 'known-answer hashes' -Fixture {
        It -Name 'computes <Algorithm>("<Input>") = <Expected>' -ForEach $script:Cases -Test {
            Get-StringHash -String $Input -Algorithm $Algorithm | Should -Be $Expected
        }
    }

    Context -Name 'defaults' -Fixture {
        It -Name 'defaults to SHA256' -Test {
            Get-StringHash -String 'abc' |
                Should -Be 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'
        }
    }

    Context -Name 'pipeline' -Fixture {
        It -Name 'accepts string input from the pipeline' -Test {
            ('abc' | Get-StringHash -Algorithm SHA256) |
                Should -Be 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an unknown algorithm' -Test {
            { Get-StringHash -String 'abc' -Algorithm 'SHA3' } | Should -Throw
        }
    }
}
