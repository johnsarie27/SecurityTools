function New-AggregateReport {
    <# =========================================================================
    .SYNOPSIS
        Aggregate and merge scan results into a single report
    .DESCRIPTION
        This function takes a web scan and system scan report and applies
        standard filters and columns to each for easy review in a single
        spreadsheet with multiple tabs.
    .PARAMETER SystemScan
        Path to System scan as a sting
    .PARAMETER WebScan
        Path to Web scan as a string
    .PARAMETER DatabaseScan
        Path to Database scan as a string
    .INPUTS
        System.String. Format-ScanResults accepts string values for SystemScan
        and WebScan parameters.
    .OUTPUTS
        Com.Excel.Application. Format-ScanResults returns an Excel spreadsheet
    .EXAMPLE
        PS C:\> New-AggregateReport -SystemScan $Sys -WebScan $Web
        Merge and aggregate data from $Sys and $Web scans into a pre-filtered
        report for easy review.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'sys', HelpMessage = 'CSV file for system scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb')]
        [Parameter(Mandatory, ParameterSetName = 'sysdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [Alias('SystemPath', 'SystemFile', 'System')]
        [string] $SystemScan,

        [Parameter(Mandatory, ParameterSetName = 'web', HelpMessage = 'CSV file for web scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysweb')]
        [Parameter(Mandatory, ParameterSetName = 'webdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [Alias('WebPath', 'WebFile', 'Web')]
        [string] $WebScan,

        [Parameter(Mandatory, ParameterSetName = 'db', HelpMessage = 'CSV file for DB scan report')]
        [Parameter(Mandatory, ParameterSetName = 'sysdb')]
        [Parameter(Mandatory, ParameterSetName = 'webdb')]
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.csv" })]
        [Alias('DbPath', 'DbFile', 'DataBase', 'D')]
        [string] $DatabaseScan
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name UtilityFunctions

        # SET VARS
        $Properties = @(
            "IP-address"
            "Detected Hostname"
            "Port number"
            "Exposure ID"
            "Name"
            "Protocol"
            "Service Description"
            "Severity"
            "CVSS"
            "Description"
            "Impact"
            "Resolution"
            "Evidence"
            "References"
        )

        $ActiveWhere = { $_.'Active or inactive' -ne 'Global inactive' -and $_.Severity -ne 'Informational' }
        $InactiveWhere = { $_.'Active or inactive' -match 'inactive' -or $_.Severity -eq 'Informational' }

        # GET SAVE FOLDER
        $Outdir = "$HOME\Desktop" # Get-Folder -Description "Save location"

        # STAGE SPLATTER TABLE
        $Splat = @{
            Freeze = $true
            Path   = Join-Path -Path $Outdir -ChildPath ('Aggregate-Scans_{0}.xlsx' -f (Get-Date -F "yyyy-MM"))
        }
        if ( $PSCmdlet.ParameterSetName -ne 'db' ) { $Splat.SuppressOpen = $true }
    }
    
    Process {
        # PROCESS DB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('DatabaseScan') ) {
            $DbCsv = Import-Csv -Path $DatabaseScan
            $DbCsv | ForEach-Object -Process { $_ | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Database Scan' }

            # EXPORT DB DATA TO EXCEL
            $DbCsv | Select-Object -ExcludeProperty Source | Export-ExcelBook @Splat -SheetName 'DBScan'
        }
            
        # PROCESS WEB SCAN DATA
        if ( $PSBoundParameters.ContainsKey('WebScan') ) {
            $WebCsv = Import-Csv -Path $WebScan
            $WebCsv | ForEach-Object -Process { $_ | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'Web Scan' }
            
            # EXPORT WEB DATA TO EXCEL
            $WebCsv | Where-Object $ActiveWhere | Select-Object -Property $Properties |
                Export-ExcelBook @Splat -SheetName 'WebScan'
            
            # INACTIVE OR INFO
            $InactiveWeb = $WebCsv | Where-Object $InactiveWhere
        }

        # PROCESS SYSTEM SCAN DATA
        if ( $PSBoundParameters.ContainsKey('SystemScan') ) {
            $SystemCsv = Import-Csv -Path $SystemScan
            $SystemCsv | ForEach-Object -Process { $_ | Add-Member -MemberType NoteProperty -Name 'Source' -Value 'System Scan' }
            
            # ADD SYSTEM SPECIFIC PROPERTIES
            $Properties += @("Detected OS", "CVE")
            
            # EXPORT SYSTEM DATA TO EXCEL
            $SystemCsv | Where-Object $ActiveWhere | Select-Object -Property $Properties |
                Export-ExcelBook @Splat -SheetName 'SystemScan'
            
            # INACTIVE OR INFO
            $InactiveSystem = $SystemCsv | Where-Object $InactiveWhere
        }
    }
    
    End {
        # ADD INACTIVE OR INFORMATIONAL TAB
        if ( $PSCmdlet.ParameterSetName -ne 'db' ) {

            # CHECK FOR INACTIVE OBJECT ARRAYS AND COMBINE INTO SINGEL ARRAY
            if ( $InactiveWeb -and $InactiveSystem ) { $AllInactive = $InactiveWeb + $InactiveSystem }
            elseif ( $InactiveWeb ) { $AllInactive = $InactiveWeb }
            elseif ( $InactiveSystem ) { $AllInactive = $InactiveSystem }
            
            # ADD SOURCE TO PROPERTIES AND REMOVE SUPPRESS OPEN
            $Properties += "Source"
            $Splat.Remove('SuppressOpen')
            
            # EXPORT ALL INACTIVE DATA TO EXCEL
            $AllInactive | Select-Object -Property $Properties | Export-ExcelBook @Splat -SheetName 'Inactive'
        }
    }
}