BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-GreyNoiseIPStatus' -Fixture {

    BeforeAll {
        # A valid-looking key so ValidateLength(20,100) passes.
        $script:FakeKey = 'a' * 32
    }

    Context -Name 'request shape' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{
                    noise          = $false
                    riot           = $false
                    classification = 'benign'
                    name           = 'Google DNS'
                    link           = 'https://viz.greynoise.io/ip/8.8.8.8'
                    last_seen      = '2024-01-01'
                    message        = 'Success'
                }
            }
        }

        It -Name 'GETs the GreyNoise community endpoint with the IP appended' -Test {
            Get-GreyNoiseIPStatus -IPAddress '8.8.8.8' -ApiKey $script:FakeKey | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Uri -eq 'https://api.greynoise.io/v3/community/8.8.8.8' -and $Method -eq 'Get'
            }
        }

        It -Name 'sends Accept, Content-Type, and key headers when -ApiKey is provided' -Test {
            Get-GreyNoiseIPStatus -IPAddress '8.8.8.8' -ApiKey $script:FakeKey | Out-Null
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                -ParameterFilter {
                $Headers['Accept'] -eq 'application/json' -and
                $Headers['Content-Type'] -eq 'application/json' -and
                $Headers['key'] -eq $script:FakeKey
            }
        }

        It -Name 'omits the key header when -ApiKey is not provided' -Test {
            $script:original = $env:GREYNOISE_API_KEY
            Remove-Item -Path 'Env:GREYNOISE_API_KEY' -ErrorAction Ignore
            try {
                Get-GreyNoiseIPStatus -IPAddress '8.8.8.8' | Out-Null
                Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName `
                    -ParameterFilter { -not $Headers.ContainsKey('key') }
            }
            finally {
                if ($script:original) { $env:GREYNOISE_API_KEY = $script:original }
            }
        }
    }

    Context -Name 'response handling' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{
                    noise          = $true
                    riot           = $false
                    classification = 'malicious'
                    name           = 'Bad Actor'
                    link           = 'https://viz.greynoise.io/ip/1.2.3.4'
                    last_seen      = '2024-06-01'
                    message        = 'ok'
                }
            }
        }

        It -Name 'projects the response into a PSCustomObject with mapped Status' -Test {
            $result = Get-GreyNoiseIPStatus -IPAddress '1.2.3.4' -ApiKey $script:FakeKey
            $result.IPAddress.IPAddressToString | Should -Be '1.2.3.4'
            $result.Classification              | Should -Be 'malicious'
            $result.Noise                       | Should -BeTrue
            $result.Status                      | Should -Be 'MALICIOUS - Known Threat Actor (Actively Scanning)'
        }

        It -Name 'emits one object per IP when given an array' -Test {
            $result = Get-GreyNoiseIPStatus -IPAddress '1.2.3.4', '5.6.7.8' -ApiKey $script:FakeKey
            $result.Count | Should -Be 2
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an -ApiKey shorter than 20 characters' -Test {
            { Get-GreyNoiseIPStatus -IPAddress '8.8.8.8' -ApiKey 'tooshort' } | Should -Throw
        }
    }
}
