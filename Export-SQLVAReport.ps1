function Export-SQLVAReport {
    <# =========================================================================
    .SYNOPSIS
        This function is used to scan SQL Server DBs for Vulnerabilities
    .DESCRIPTION
        The script relies on the native Vulnerability Assessment scan tool imbedded
        in SQL Server Management Studio 17.0 & up
    .PARAMETER ServerName
        Name of SQL Server
    .PARAMETER DestinationPath
        Path to output directory for new SQL Vulnerability Assessment reports
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> .\Export-SQLVAReport.ps1 -CP C:\config.json
        This exports out a scan report using SQL Vulnerability Assessment tool for
        each database in the provided configuraiton file.
    .NOTES
        General notes
        https://docs.microsoft.com/en-us/sql/relational-databases/security/sql-vulnerability-assessment?view=sql-server-2017
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'SQL server name')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Quiet -Count 1 })]
        [Alias('SN', 'Server')]
        [string[]] $ServerName,

        [Parameter(HelpMessage = 'Output directory')]
        [ValidateScript( { Test-Path -Path $_ -PathType Container })]
        [Alias('OP', 'Output')]
        [string] $DestinationPath = "D:\MSSQL-VA",

        [Parameter(HelpMessage = 'Return path to report directory')]
        [switch] $PassThru
    )

    Begin {
        # IMPORT REQUIRED MODULES
        Import-Module -Name SqlServer

        # GET DATE OBJECTS AND SET OUTPUT FOLDER
        $Date = Get-Date
        $DateFolder = '{0}\{1}' -f $Date.ToString("yyyy"), $Date.ToString("MM")
        $Folder = Join-Path -Path $DestinationPath -ChildPath $DateFolder

        # CREATE FOLDER IF NOT EXIST
        if ( -not (Test-Path -Path $Folder) ) {
            try { New-Item -Path $Folder -ItemType Directory }
            catch { Write-Error ('Could not create folder path: [{0}]' -f $Folder) }
        }
    }

    Process {
        # LOOP THROUGH ALL DB SERVERS
        foreach ( $Server in $ServerName ) {

            # CREATE FILE
            $ReportFile = '{0}_{1}.xlsx' -f (Get-Date -F "yyyy-MM-dd"), $Server

            # EXECUTE SCAN AND SET TO VARIABLE
            $Scan = Invoke-SqlVulnerabilityAssessmentScan -ServerInstance $Server -DatabaseName "master"

            # EXPORT SCAN RESULT TO EXCEL SPREADSHEET
            $Scan | Export-SqlVulnerabilityAssessmentScan -FolderPath (Join-Path -Path $Folder -ChildPath $ReportFile)

            # RETURN PATH TO REPORT FOLDER
            if ( $PSBoundParameters.ContainsKey('PassThru') ) { Write-Output $Folder }
        }
    }
}