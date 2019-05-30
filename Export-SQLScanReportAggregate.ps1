function Export-SQLScanReportAggregate {
    <# =========================================================================
    .SYNOPSIS
        Aggregate results from SQL Vulnerability Assessment scans
    .DESCRIPTION
        Aggregate results from SQL Vulnerability Assessment scans into a single report
    .PARAMETER InputPath
        Path to directory of SQL Vulnerability Assessemnt file(s)
    .PARAMETER ZipPath
        Path to zip file containing repots
    .PARAMETER OutputPath
        Path to output report file
    .PARAMETER PassThru
        Return report path
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Export-SQLScanReportAggregate -InputPath (Get-ChildItem C:\MyScans).FullName
        Combine all scans in C:\MyScans folder into a single report and output to the desktop.
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = 'folder')]
    Param(
        [Parameter(
            Mandatory, ParameterSetName = 'folder',
            HelpMessage = 'Path to directory of SQL Vulnerability Assessemnt file(s)'
        )]
        [ValidateScript({ Get-ChildItem -Path $_ -Include "*.xlsx" -Recurse })]
        [Alias('IP', 'Directory', 'Input')]
        [string] $InputPath,

        [Parameter(
            Mandatory, ParameterSetName = 'zip',
            HelpMessage = 'Path to zip file containing reports'
        )]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.zip" })]
        [Alias('Zip', 'ZP')]
        [string] $ZipPath,

        [Parameter(HelpMessage = 'Path to output report file')]
        [ValidateScript({
            if ( (Test-Path -Path (Split-Path -Path $_) -PathType Container) -and `
            ((Split-Path -Path $_ -Leaf) -match '^[\w-]+\.xlsx$') ) { Return $true }
        })]
        [ValidateNotNullOrEmpty()]
        [Alias('OP', 'Output')]
        [string] $OutputPath,

        [Parameter(HelpMessage = 'Return path to aggreate report')]
        [switch] $PassThru
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

        # GET REPORTS FROM ZIP
        if ( $PSBoundParameters.ContainsKey('ZipPath') ) {
            # EXTRACT FILES
            Expand-Archive -Path $ZipPath -DestinationPath ($ExpandPath = "$HOME\Desktop\Extract")

            # RESET INPUTPATH VAR
            $InputPath = $ExpandPath
        }

        # GET REPORTS FROM FOLDER
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
        if ( $PSBoundParameters.ContainsKey('PassThru') ) { Write-Output $OutputPath }

        # REMOVE EXTRACTED FILES
        if ( $ExpandPath ) { Remove-Item -Path $InputPath -Recurse -Force }
    }
}