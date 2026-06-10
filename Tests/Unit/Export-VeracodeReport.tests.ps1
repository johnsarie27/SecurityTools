BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Export-VeracodeReport' -Fixture {

    BeforeAll {
        # Minimal Veracode detailedreport XML covering the two shapes the function reaches into:
        # detailedreport.severity[].category.cwe.staticflaws.flaw (vulnerabilities) and
        # detailedreport.'static-analysis'.modules.module (modules)
        $script:ReportPath = Join-Path -Path $TestDrive -ChildPath 'veracode.xml'
        $reportXml = @'
<?xml version="1.0" encoding="UTF-8"?>
<detailedreport>
  <severity level="5">
    <category categoryname="SQL Injection">
      <cwe cweid="89">
        <staticflaws>
          <flaw severity="5" module="api.dll" type="SQLi" sourcefile="db.cs" line="42" scope="Db.Run" categoryname="SQL Injection" issueid="1001" />
          <flaw severity="5" module="api.dll" type="SQLi" sourcefile="db.cs" line="77" scope="Db.Run" categoryname="SQL Injection" issueid="1002" />
        </staticflaws>
      </cwe>
    </category>
  </severity>
  <severity level="3">
    <category categoryname="XSS">
      <cwe cweid="79">
        <staticflaws>
          <flaw severity="3" module="web.dll" type="XSS" sourcefile="view.cs" line="10" scope="View.Render" categoryname="XSS" issueid="2001" />
        </staticflaws>
      </cwe>
    </category>
  </severity>
  <static-analysis>
    <modules>
      <module name="api.dll" compiler="csc" os="Windows" architecture="x64"
              numflawssev0="0" numflawssev1="0" numflawssev2="0" numflawssev3="0" numflawssev4="0" numflawssev5="2" />
      <module name="web.dll" compiler="csc" os="Windows" architecture="x64"
              numflawssev0="0" numflawssev1="0" numflawssev2="0" numflawssev3="1" numflawssev4="0" numflawssev5="0" />
    </modules>
  </static-analysis>
</detailedreport>
'@
        Set-Content -Path $script:ReportPath -Value $reportXml -Encoding utf8

        $script:OutDir = Join-Path -Path $TestDrive -ChildPath 'out'
        New-Item -Path $script:OutDir -ItemType Directory -Force | Out-Null

        # Replace Excel I/O so the test stays hermetic
        Mock -CommandName Export-Excel    -MockWith {} -ModuleName $env:BHProjectName
        Mock -CommandName New-ExcelStyle  -MockWith { @{} } -ModuleName $env:BHProjectName
    }

    Context -Name 'command metadata' -Fixture {
        BeforeAll {
            $script:Cmd = Get-Command -Name 'Export-VeracodeReport' -Module $env:BHProjectName
        }

        It -Name 'is exported by the module' -Test {
            $script:Cmd | Should -Not -BeNullOrEmpty
        }

        It -Name 'declares -VeracodeXML as mandatory' -Test {
            $script:Cmd.Parameters['VeracodeXML'].Attributes.Mandatory | Should -Contain $true
        }
    }

    Context -Name 'workbook export' -Fixture {
        It -Name 'writes the Modules and Vulnerabilities worksheets' -Test {
            Export-VeracodeReport -VeracodeXML $script:ReportPath -OutputDirectory $script:OutDir
            foreach ($sheet in 'Modules', 'Vulnerabilities') {
                Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                    -ParameterFilter { $WorksheetName -eq $sheet }
            }
        }

        It -Name 'writes a dated VeracodeScan workbook under -OutputDirectory' -Test {
            Export-VeracodeReport -VeracodeXML $script:ReportPath -OutputDirectory $script:OutDir
            Should -Invoke -CommandName Export-Excel -ModuleName $env:BHProjectName `
                -ParameterFilter { $Path -match '\d{4}-\d{2}-\d{2}_VeracodeScan\.xlsx$' -and (Split-Path -Path $Path -Parent) -eq $script:OutDir }
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -VeracodeXML path that does not exist' -Test {
            { Export-VeracodeReport -VeracodeXML (Join-Path -Path $TestDrive -ChildPath 'missing.xml') } | Should -Throw
        }

        It -Name 'rejects a -VeracodeXML file whose extension is not .xml' -Test {
            $bogus = Join-Path -Path $TestDrive -ChildPath 'report.txt'
            Set-Content -Path $bogus -Value '<not xml/>'
            { Export-VeracodeReport -VeracodeXML $bogus } | Should -Throw
        }

        It -Name 'rejects an -OutputDirectory that does not exist' -Test {
            { Export-VeracodeReport -VeracodeXML $script:ReportPath -OutputDirectory (Join-Path -Path $TestDrive -ChildPath 'nope') } | Should -Throw
        }
    }
}
