BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }

    # Get-GPResultantSetOfPolicy comes from the GroupPolicy RSAT module, which is only present
    # on domain-tooled Windows hosts; tests adapt to whether it is installed
    $HasGroupPolicy = [bool] (Get-Module -ListAvailable -Name 'GroupPolicy')
}

Describe -Name 'Get-RSOP' -Fixture {

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Get-RSOP' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -Path as mandatory' -Test {
            $script:Cmd.Parameters['Path'].Attributes.Mandatory | Should -Contain $true
        }

        It -Name 'limits -ReportType to HTML and XML' -Test {
            $validateSet = $script:Cmd.Parameters['ReportType'].Attributes |
                Where-Object -FilterScript { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $validateSet.ValidValues | Should -Be @('HTML', 'XML')
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a report path in a nonexistent directory' -Test {
            $badPath = Join-Path -Path $TestDrive -ChildPath 'no-such-dir' -AdditionalChildPath 'rsop.html'
            { Get-RSOP -Path $badPath } | Should -Throw
        }

        It -Name 'rejects a -ReportType outside the valid set' -Test {
            $path = Join-Path -Path $TestDrive -ChildPath 'rsop.pdf'
            { Get-RSOP -Path $path -ReportType 'PDF' } | Should -Throw
        }
    }

    Context -Name 'GroupPolicy module dependency' -Fixture {
        # The Begin block hard-imports GroupPolicy with -ErrorAction Stop; on hosts without
        # RSAT this must surface as a terminating error instead of running with missing commands
        It -Name 'throws when the GroupPolicy module is unavailable' -Skip:$HasGroupPolicy -Test {
            $path = Join-Path -Path $TestDrive -ChildPath 'rsop.html'
            { Get-RSOP -Path $path } | Should -Throw
        }
    }
}
