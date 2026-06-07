BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Get-KEVList' -Fixture {

    BeforeAll {
        # Minimal response mimicking the CISA KEV JSON feed structure
        $mockResponse = [PSCustomObject] @{
            title           = 'CISA Known Exploited Vulnerabilities Catalog'
            catalogVersion  = '2024.01.01'
            vulnerabilities = @(
                [PSCustomObject] @{ cveID = 'CVE-2021-44228'; vendorProject = 'Apache'; product = 'Log4j' }
                [PSCustomObject] @{ cveID = 'CVE-2020-2659'; vendorProject = 'Oracle'; product = 'Java SE' }
            )
        }

        Mock -CommandName Invoke-RestMethod -MockWith { $mockResponse } -ModuleName $env:BHProjectName
        Mock -CommandName Invoke-WebRequest -MockWith {} -ModuleName $env:BHProjectName
    }

    Context -Name 'default (no Format)' -Fixture {
        It -Name 'returns a response object' -Test {
            $result = Get-KEVList
            $result | Should -Not -BeNullOrEmpty
        }

        It -Name 'calls Invoke-RestMethod (not Invoke-WebRequest)' -Test {
            Get-KEVList
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1
        }

        It -Name 'should not throw' -Test {
            { Get-KEVList } | Should -Not -Throw
        }
    }

    Context -Name 'Format parameter triggers file download' -Fixture {
        BeforeAll {
            New-Item -Path 'TestDrive:/kev' -ItemType Directory -Force | Out-Null
        }

        It -Name 'calls Invoke-WebRequest when Format is specified' -Test {
            Get-KEVList -Format 'JSON' -OutputDirectory 'TestDrive:/kev'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName -Times 1
        }

        It -Name 'uses the CSV catalog URL when -Format CSV is specified' -Test {
            Get-KEVList -Format 'CSV' -OutputDirectory 'TestDrive:/kev'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like '*known_exploited_vulnerabilities.csv' }
        }

        It -Name 'uses the schema URL when -Format Schema is specified' -Test {
            Get-KEVList -Format 'Schema' -OutputDirectory 'TestDrive:/kev'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -like '*known_exploited_vulnerabilities_schema.json' }
        }

        It -Name 'writes -OutFile under the supplied OutputDirectory' -Test {
            Get-KEVList -Format 'JSON' -OutputDirectory 'TestDrive:/kev'
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $OutFile -like '*kev*known_exploited_vulnerabilities.json' }
        }
    }

    Context -Name 'OutputDirectory validation' -Fixture {
        It -Name 'throws when OutputDirectory does not exist' -Test {
            { Get-KEVList -Format 'JSON' -OutputDirectory 'TestDrive:/no-such-dir' } |
            Should -Throw -ExpectedMessage '*Invalid output directory*'
        }

        It -Name 'throws when OutputDirectory points at a file rather than a directory' -Test {
            $file = Join-Path -Path $TestDrive -ChildPath 'a-file.txt'
            Set-Content -Path $file -Value 'x'
            { Get-KEVList -Format 'JSON' -OutputDirectory $file } |
            Should -Throw -ExpectedMessage '*Invalid output directory*'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an unknown -Format value' -Test {
            { Get-KEVList -Format 'XML' -OutputDirectory 'TestDrive:/kev' } | Should -Throw
        }
    }

    Context -Name 'transport / file-I/O failure' -Fixture {
        BeforeAll {
            New-Item -Path 'TestDrive:/kev-fail' -ItemType Directory -Force | Out-Null
        }

        It -Name 'propagates Invoke-WebRequest failures from the download path' -Test {
            Mock -CommandName Invoke-WebRequest -MockWith {
                throw [System.IO.IOException]::new('cannot write to OutFile')
            } -ModuleName $env:BHProjectName
            { Get-KEVList -Format 'JSON' -OutputDirectory 'TestDrive:/kev-fail' } |
            Should -Throw -ExpectedMessage '*cannot write to OutFile*'
        }

        It -Name 'propagates Invoke-RestMethod failures from the default path' -Test {
            Mock -CommandName Invoke-RestMethod -MockWith {
                throw [System.Net.WebException]::new('feed unavailable')
            } -ModuleName $env:BHProjectName
            { Get-KEVList } | Should -Throw -ExpectedMessage '*feed unavailable*'
        }
    }
}
