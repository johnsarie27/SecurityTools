function Export-SQLScanReportAggregate {
    <# =========================================================================
    .SYNOPSIS
        Aggregate results from SQL Vulnerability Assessment scans
    .DESCRIPTION
        Aggregate results from SQL Vulnerability Assessment scans into a single report
    .PARAMETER InputPath
        Path to SQL Vulnerability Assessemnt report file
    .PARAMETER OutputPath
        Path to output report file
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Export-SQLScanReportAggregate -InputPath (Get-ChildItem C:\MyScans).FullName
        Combine all scans in C:\MyScans folder into a single report and output to the desktop.
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Path to SQL Vulnerability Assessemnt report file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xlsx" })]
        [Alias('IP', 'Report', 'Input')]
        [string[]] $InputPath,

        [Parameter(HelpMessage = 'Path to output report file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xlsx" })]
        [Alias('OP', 'Output')]
        [string] $OutputPath
    )

    Begin {
        # IMPORT REQUIRED MODULE
        Import-Module -Name ImportExcel

        # CREATE ARRAY
        $ReportData = @()

        # GET OUTPUT PATH
        if ( -not $PSBoundParameters.ContainsKey('OutputPath') ) {
            # STORE ON DESKTOP
            Join-Path -Path "$HOME\Desktop" -ChildPath ('Aggregate-SQL-Scans_{0}.xlsx' -f (Get-Date -F "yyyy-MM"))
        }
    }

    Process {
        # LOOP THROUGH ALL PROVIDED REPORTS
        foreach ( $Report in $InputPath ) {
            # ADD TO ARRAY
            $ReportData += Import-Excel -Path $Report -StartRow 8 -WorksheetName Results
        }
    }

    End {
        # SET EXCEL PARAMS
        $ExcelParams = @{
            AutoFilter    = $true
            BoldTopRow    = $true
            FreezeTopRow  = $true
            MoveToEnd     = $true
            Path          = $OutputPath
            WorksheetName = 'DBScan'
        }

        # EXPORT NEW AGGREATE REPORT
        $ReportData | Export-Excel @ExcelParams

        # RETURN PATH TO REPORT
        Write-Output $OutputPath
    }
}