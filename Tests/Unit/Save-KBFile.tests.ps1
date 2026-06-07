BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Save-KBFile' -Fixture {

    BeforeAll {
        # The function does two Invoke-WebRequest hops (catalog Search.aspx, then DownloadDialog.aspx)
        # and then either Start-BitsTransfer (Windows only) or [Net.WebClient]::DownloadFile to grab
        # the binary. Mock the IWR calls; the search response yields no InputFields/Links so the
        # function will warn ("no results found") and return without ever invoking a downloader.
        Mock -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName -MockWith {
            [PSCustomObject] @{
                InputFields = @()
                Links       = @()
                Content     = ''
            }
        }
        Mock -CommandName Write-Warning -ModuleName $env:BHProjectName
    }

    Context -Name 'URL construction' -Fixture {
        It -Name 'queries catalog.update.microsoft.com/Search.aspx?q=KB<n> with the numeric KB ID' -Test {
            Save-KBFile -Name 'KB4057119' | Out-Null
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'http://www.catalog.update.microsoft.com/Search.aspx?q=KB4057119' }
        }

        It -Name 'strips a leading "KB" from -Name when building the search URL' -Test {
            Save-KBFile -Name '4057119' | Out-Null
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName `
                -ParameterFilter { $Uri -eq 'http://www.catalog.update.microsoft.com/Search.aspx?q=KB4057119' }
        }

        It -Name 'issues one search request per -Name when an array is passed' -Test {
            Save-KBFile -Name 'KB1', 'KB2', 'KB3' | Out-Null
            Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName -Times 3 -Exactly `
                -ParameterFilter { $Uri -like '*Search.aspx?q=KB*' }
        }
    }

    Context -Name 'no-results behavior' -Fixture {
        It -Name 'warns and skips the downloader when the catalog returns no matching downloads' -Test {
            Save-KBFile -Name 'KB9999999' | Out-Null
            Should -Invoke -CommandName Write-Warning -ModuleName $env:BHProjectName
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects an -Architecture value outside the validated set' -Test {
            { Save-KBFile -Name 'KB1' -Architecture 'ia64' } | Should -Throw
        }

        It -Name 'accepts -Architecture values x64, x86, and All' -Test {
            foreach ($a in 'x64', 'x86', 'All') {
                { Save-KBFile -Name 'KB1' -Architecture $a } | Should -Not -Throw
            }
        }

        It -Name 'errors when -FilePath is combined with more than one -Name' -Test {
            { Save-KBFile -Name 'KB1', 'KB2' -FilePath 'C:\out.cab' -ErrorAction Stop } |
                Should -Throw -ExpectedMessage '*only one KB when using FilePath*'
        }

        It -Name 'allows -FilePath with exactly one -Name' -Test {
            # Invoke-WebRequest is mocked to return no matching downloads, so the function warns
            # and returns without ever touching the downloader.
            { Save-KBFile -Name 'KB1' -FilePath 'C:\out.cab' -ErrorAction Stop } | Should -Not -Throw
        }
    }
}
