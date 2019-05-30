function Export-SQLScanReportAggregate {
    <# =========================================================================
    .SYNOPSIS
        Aggregate results from SQL Vulnerability Assessment scans
    .DESCRIPTION
        Aggregate results from SQL Vulnerability Assessment scans into a single report
    .PARAMETER InputPath
        Path to directory of SQL Vulnerability Assessemnt file(s)
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
        [Parameter(Mandatory, HelpMessage = 'Path to directory of SQL Vulnerability Assessemnt file(s)')]
        [ValidateScript({ Get-ChildItem -Path $_ -Include "*.xlsx" -Recurse })]
        [Alias('IP', 'Directory', 'Input')]
        [string] $InputPath,

        [Parameter(HelpMessage = 'Path to output report file')]
        #[ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xlsx" })]
        [ValidateNotNullOrEmpty()]
        [Alias('OP', 'Output')]
        [string] $OutputPath
    )

    Begin {
        # IMPORT REQUIRED MODULE
        Import-Module -Name ImportExcel

        # CREATE ARRAY
        $Data = @()

        # GET OUTPUT PATH
        if ( -not $PSBoundParameters.ContainsKey('OutputPath') ) {
            # STORE ON DESKTOP
            $OutputPath = Join-Path -Path "$HOME\Desktop" -ChildPath ('Aggregate-SQL-Scans_{0}.xlsx' -f (Get-Date -F "yyyy-MM"))
        }

        # GET REPORTS
        $ReportFiles = Get-ChildItem -Path ('{0}\*.xlsx' -f $InputPath)
    }

    Process {
        # LOOP THROUGH ALL PROVIDED REPORTS
        foreach ( $Report in $ReportFiles.FullName ) {
            # ADD TO ARRAY
            $Data += Import-Excel -Path $Report -StartRow 8 -WorksheetName Results
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
        $Data | Export-Excel @ExcelParams

        # RETURN PATH TO REPORT
        Write-Output $OutputPath
    }
}