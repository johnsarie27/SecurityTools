BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Uninstall-MSI' -Fixture {

    # Uninstall-MSI calls MsiExec.exe and reads HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall.
    # The Begin block throws on non-Windows hosts before any of that runs, so happy-path execution
    # can only be exercised on Windows. CI runs on ubuntu-latest, so we limit body-level invocations
    # to a skip-guarded block and cover the rest via metadata.

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Uninstall-MSI' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -ProductId as mandatory positional' -Test {
            $param = $script:Cmd.Parameters['ProductId']
            $param.Attributes.Mandatory | Should -Contain $true
            $param.Attributes.Position  | Should -Contain 0
        }

        It -Name 'supports ShouldProcess with High confirm impact' -Test {
            $cmdletBinding = $script:Cmd.ScriptBlock.Attributes |
            Where-Object -FilterScript { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
            $cmdletBinding.SupportsShouldProcess | Should -BeTrue
            $cmdletBinding.ConfirmImpact         | Should -Be 'High'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -ProductId that does not match the GUID pattern' -Test {
            { Uninstall-MSI -ProductId 'not-a-guid' } | Should -Throw
        }

        It -Name 'rejects an empty -ProductId' -Test {
            { Uninstall-MSI -ProductId '' } | Should -Throw
        }

        It -Name 'accepts a well-formed all-caps GUID' -Test {
            # ValidatePattern does not require braces. We use -WhatIf so the function never actually
            # touches the registry. On non-Windows it will throw with the OS-required message; on
            # Windows it will short-circuit on "application not found" since the GUID is bogus.
            if ($IsWindows) {
                { Uninstall-MSI -ProductId '109A5A16-E09E-4B82-A784-D1780F1190D6' -WhatIf } | Should -Not -Throw
            }
            else {
                { Uninstall-MSI -ProductId '109A5A16-E09E-4B82-A784-D1780F1190D6' -WhatIf } |
                Should -Throw -ExpectedMessage '*requires Windows*'
            }
        }
    }

    Context -Name 'platform guard' -Fixture {
        It -Name 'errors with a Windows-required message on non-Windows hosts' -Skip:($IsWindows) -Test {
            { Uninstall-MSI -ProductId '109A5A16-E09E-4B82-A784-D1780F1190D6' } |
            Should -Throw -ExpectedMessage '*requires Windows*'
        }
    }

    Context -Name 'happy path (Windows only)' -Fixture {
        It -Name 'reports "Application... not found" when no registry entry matches the GUID' -Skip:(-not $IsWindows) -Test {
            # Use a GUID that is overwhelmingly unlikely to be installed
            $result = Uninstall-MSI -ProductId 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF'
            $result | Should -Match 'not found'
        }
    }
}
