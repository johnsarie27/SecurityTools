BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'ConvertFrom-IISLog' -Fixture {

    BeforeAll {
        # Minimal IIS W3C log: software/version/date headers, a #Fields header, and two data rows.
        $script:LogContent = @'
#Software: Microsoft Internet Information Services 10.0
#Version: 1.0
#Date: 2024-01-15 00:00:00
#Fields: date time c-ip cs-method cs-uri-stem sc-status
2024-01-15 00:00:01 10.0.0.1 GET /index.html 200
2024-01-15 00:00:02 10.0.0.2 POST /api/login 401
'@

        $script:LogPath = Join-Path -Path 'TestDrive:' -ChildPath 'sample.log'
        Set-Content -Path $script:LogPath -Value $script:LogContent
    }

    Context -Name 'parses W3C-formatted log lines' -Fixture {
        It -Name 'returns one PSCustomObject per non-comment line' -Test {
            $result = ConvertFrom-IISLog -Path $script:LogPath
            $result.Count | Should -Be 2
        }

        It -Name 'maps #Fields header tokens to property names' -Test {
            $result = ConvertFrom-IISLog -Path $script:LogPath
            $result[0].PSObject.Properties.Name | Should -Contain 'date'
            $result[0].PSObject.Properties.Name | Should -Contain 'cs-method'
            $result[0].PSObject.Properties.Name | Should -Contain 'sc-status'
        }

        It -Name 'populates each property from the matching position in the data row' -Test {
            $result = ConvertFrom-IISLog -Path $script:LogPath
            $result[0].'c-ip'        | Should -Be '10.0.0.1'
            $result[0].'cs-method'   | Should -Be 'GET'
            $result[0].'cs-uri-stem' | Should -Be '/index.html'
            $result[0].'sc-status'   | Should -Be '200'
            $result[1].'cs-method'   | Should -Be 'POST'
            $result[1].'sc-status'   | Should -Be '401'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a non-existent path' -Test {
            { ConvertFrom-IISLog -Path 'TestDrive:/missing.log' } | Should -Throw
        }

        It -Name 'rejects a path that does not end in .log' -Test {
            $badPath = Join-Path -Path 'TestDrive:' -ChildPath 'sample.txt'
            Set-Content -Path $badPath -Value 'whatever'
            { ConvertFrom-IISLog -Path $badPath } | Should -Throw
        }
    }
}
