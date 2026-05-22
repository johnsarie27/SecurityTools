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
    }
}
