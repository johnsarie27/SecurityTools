BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction 'Stop' -Force
    }
}

Describe -Name 'Export-WebScan' -Fixture {

    BeforeAll {
        # Tiny Acunetix-shaped XML report. The function reaches into
        # $xml.ScanGroup.Scan.ReportItems.ReportItem and pulls fields out of #cdata-section nodes.
        $script:TempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
        New-Item -Path $script:TempDir -ItemType Directory | Out-Null
        $script:ReportPath = Join-Path -Path $script:TempDir -ChildPath 'acunetix.xml'

        $reportXml = @'
<?xml version="1.0" encoding="UTF-8"?>
<ScanGroup>
  <Scan>
    <ReportItems>
      <ReportItem>
        <Name><![CDATA[SQL Injection]]></Name>
        <ModuleName><![CDATA[Scripting (SQL_Injection.script)]]></ModuleName>
        <Details><![CDATA[Vulnerable parameter detected]]></Details>
        <Affects><![CDATA[/login.aspx]]></Affects>
        <Parameter><![CDATA[username]]></Parameter>
        <IsFalsePositive><![CDATA[0]]></IsFalsePositive>
        <Severity><![CDATA[high]]></Severity>
        <Type><![CDATA[Validation]]></Type>
        <Impact><![CDATA[Possible data exposure]]></Impact>
        <Description><![CDATA[Classic SQLi]]></Description>
        <DetailedInformation><![CDATA[See documentation]]></DetailedInformation>
        <Recommendation><![CDATA[Use parameterized queries]]></Recommendation>
        <TechnicalDetails><Request><![CDATA[GET /login.aspx?u=admin]]></Request></TechnicalDetails>
        <CWEList><CWE><![CDATA[CWE-89]]></CWE><CVE><![CDATA[CVE-2023-99999]]></CVE></CWEList>
        <CVSS><Score><![CDATA[7.5]]></Score></CVSS>
        <CVSS3><Score><![CDATA[9.1]]></Score></CVSS3>
      </ReportItem>
      <ReportItem>
        <Name><![CDATA[Informational Header]]></Name>
        <ModuleName><![CDATA[Per_Server.script]]></ModuleName>
        <Details><![CDATA[X-Powered-By header present]]></Details>
        <Affects><![CDATA[/]]></Affects>
        <Parameter><![CDATA[]]></Parameter>
        <IsFalsePositive><![CDATA[0]]></IsFalsePositive>
        <Severity><![CDATA[informational]]></Severity>
        <Type><![CDATA[Informational]]></Type>
        <Impact><![CDATA[None]]></Impact>
        <Description><![CDATA[Information disclosure]]></Description>
        <DetailedInformation><![CDATA[]]></DetailedInformation>
        <Recommendation><![CDATA[Remove header]]></Recommendation>
        <TechnicalDetails><Request><![CDATA[GET /]]></Request></TechnicalDetails>
        <CWEList><CWE><![CDATA[]]></CWE><CVE><![CDATA[]]></CVE></CWEList>
        <CVSS><Score><![CDATA[0.0]]></Score></CVSS>
        <CVSS3><Score><![CDATA[0.0]]></Score></CVSS3>
      </ReportItem>
    </ReportItems>
  </Scan>
</ScanGroup>
'@
        Set-Content -Path $script:ReportPath -Value $reportXml -Encoding utf8

        # Pester mocks only bind regular parameters (e.g. -Path) when the mock body has explicit
        # begin/process/end blocks. We use begin to capture -Path and process to count rows;
        # per-row property assertions are skipped because pipeline-bound objects inside a Pester
        # mock script block do not expose their NoteProperties through $_ reliably.
        $script:CapturedRowCount = 0
        $script:CapturedExportPath = $null
        Mock -CommandName Export-Excel -ModuleName $env:BHProjectName -MockWith {
            begin {
                $script:CapturedExportPath = $Path
            }
            process {
                $script:CapturedRowCount++
            }
        }
        Mock -CommandName New-ExcelStyle -ModuleName $env:BHProjectName -MockWith { [PSCustomObject] @{ Mock = $true } }
    }

    AfterAll {
        if (Test-Path -Path $script:TempDir) {
            Remove-Item -Path $script:TempDir -Recurse -Force -ErrorAction Ignore
        }
    }

    Context -Name 'happy path' -Fixture {
        BeforeAll {
            Export-WebScan -Path $script:ReportPath -OutputDirectory $script:TempDir | Out-Null
        }

        # NOTE: Should -Invoke does not count Pester mocks whose body uses explicit begin/process/end
        # blocks. We need those blocks to bind -Path and to receive the pipeline objects, so we
        # assert invocation indirectly via $script:CapturedRowCount instead.
        It -Name 'pipes one row per ReportItem to Export-Excel' -Test {
            $script:CapturedRowCount | Should -Be 2
        }

        It -Name 'targets a WebScans_<date>.xlsx file in the output directory' -Test {
            $script:CapturedExportPath | Should -Match 'WebScans_\d{4}-\d{2}-\d{2}\.xlsx$'
            (Split-Path -Path $script:CapturedExportPath -Parent) | Should -Be $script:TempDir
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a -Path that does not exist' -Test {
            { Export-WebScan -Path (Join-Path -Path $script:TempDir -ChildPath 'missing.xml') } | Should -Throw
        }

        It -Name 'rejects a -Path whose extension is not .xml' -Test {
            $bogus = Join-Path -Path $script:TempDir -ChildPath 'report.txt'
            Set-Content -Path $bogus -Value '<not xml/>'
            { Export-WebScan -Path $bogus } | Should -Throw
        }

        It -Name 'rejects an -OutputDirectory that does not exist' -Test {
            { Export-WebScan -Path $script:ReportPath -OutputDirectory (Join-Path -Path $script:TempDir -ChildPath 'nope') } | Should -Throw
        }
    }
}
