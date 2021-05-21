function Export-VeracodeReport {
    <# =========================================================================
    .SYNOPSIS
        Export vulnerability report
    .DESCRIPTION
        Export vulnerability report from provided Veracode XML report
    .PARAMETER VeracodeXML
        XML file for Veracode scan report
    .PARAMETER OutputDirectory
        Path to output directory for new SQL Vulnerability Assessment reports
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'XML file for Veracode scan report')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xml" })]
        [string] $VeracodeXML,

        [Parameter(HelpMessage = 'Output directory')]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string] $OutputDirectory = "$HOME\Desktop"
    )
    Begin {
        [xml] $xml = Get-Content -Path $VeracodeXML
        #Write-Output $xml.detailedreport.severity

        $array = @()
        $moduleArray = @()
    }
    Process {

        # PROCESS VULNERABILITIES
        foreach ( $i in $xml.detailedreport.severity ) {

            foreach ( $c in $i.category ) {

                foreach ( $flaw in $c.cwe.staticflaws.flaw ) {

                    $array += [PSCustomObject] @{
                        reviewdate   = ''
                        approved     = ''
                        notes        = ''
                        cweid        = $c.cwe.cweid -join ', '
                        categoryname = $c.categoryname
                        severity     = $flaw.severity
                        module       = $flaw.module
                        type         = $flaw.type
                        sourcefile   = $flaw.sourcefile
                        line         = $flaw.line
                        object       = $flaw.scope
                        description  = $flaw.categoryname
                        issueid      = $flaw.issueid
                    }
                }
            }
        }

        # PROCESS MODULES
        foreach ( $module in $xml.detailedreport.'static-analysis'.modules.module ) {

            $moduleArray += [PSCustomObject] @{
                name         = $module.name
                compiler     = $module.compiler
                os           = $module.os
                architecture = $module.architecture
                sev0flaws    = $module.numflawssev0
                sev1flaws    = $module.numflawssev1
                sev2flaws    = $module.numflawssev2
                sev3flaws    = $module.numflawssev3
                sev4flaws    = $module.numflawssev4
                sev5flaws    = $module.numflawssev5
                totalflaws   = [int] $module.numflawssev0 + [int] $module.numflawssev1 + [int] $module.numflawssev2 + [int] $module.numflawssev3 + [int] $module.numflawssev4 + [int] $module.numflawssev5
            }
        }

        #$array | Format-Table -AutoSize -Property *
        #$moduleArray | Format-Table -AutoSize -Property *

        # GENERATE REPORT
        $excelParams = @{
            Path         = Join-Path -Path $OutputDirectory -ChildPath ('{0:yyyy-MM-dd}_VeracodeScan.xlsx' -f (Get-Date))
            AutoSize     = $true
            FreezeTopRow = $true
            MoveToEnd    = $true
            BoldTopRow   = $true
            AutoFilter   = $true
            Style        = (New-ExcelStyle -Bold -Range '1:1' -HorizontalAlignment Center)
        }
        $moduleArray | Export-Excel @excelParams -WorksheetName 'Modules'
        $array | Export-Excel @excelParams -WorksheetName 'Vulnerabilities'
    }
}