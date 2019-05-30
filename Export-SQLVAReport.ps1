function Export-SQLVAReport {
    <# =========================================================================
    .SYNOPSIS
        This function is used to scan SQL Server DBs for Vulnerabilities
    .DESCRIPTION
        The script relies on the native Vulnerability Assessment scan tool imbedded
        in SQL Server Management Studio 17.0 & up
    .PARAMETER ConfigPath
        Path to configuration file
    .INPUTS
        None.
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
        [Parameter(Mandatory, HelpMessage = 'Path to configuration data file')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Include "*.json" })]
        [Alias('ConfigFile', 'DataFile', 'CP', 'File')]
        [string] $ConfigPath,

        [Parameter(HelpMessage = 'Output directory')]
        [ValidateScript( { Test-Path -Path $_ -PathType Container })]
        [Alias('OP', 'Output')]
        [string] $OutputPath = "D:\MSSQL-VA",

        [Parameter(HelpMessage = 'Return path to report directory')]
        [switch] $PassThru
    )

    # IMPORT REQUIRED MODULES
    Import-Module -Name SqlServer

    # GET DATE OBJECTS AND SET OUTPUT FOLDER
    $Date = Get-Date
    $DateFolder = '{0}\{1}' -f $Date.ToString("yyyy"), $Date.ToString("MM")
    $Folder = Join-Path -Path $OutputPath -ChildPath $DateFolder

    # CREATE FOLDER IF NOT EXIST
    if ( -not (Test-Path -Path $Folder) ) { New-Item -Path $Folder -ItemType Directory }

    # GET CONFIGURATION FILE
    $Config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

    # VARIABLE CONTAINING THE LIST OF DBS TO SCAN
    $Dbs = $Config.Customers.SQLServers

    # LOOP THROUGH ALL DB SERVERS
    foreach ( $Server in $Dbs ) {

        # CREATE FILE
        $ReportFile = '{0}_{1}.xlsx' -f (Get-Date -F "yyyy-MM-dd"), $Server

        # EXECUTE SCAN AND SET TO VARIABLE
        $Result = Invoke-SqlVulnerabilityAssessmentScan -ServerInstance $Server -DatabaseName "master"

        # EXPORT SCAN RESULT TO EXCEL SPREADSHEET
        $Result | Export-SqlVulnerabilityAssessmentScan -FolderPath (Join-Path -Path $Folder -ChildPath $ReportFile)
    }

    # RETURN PATH TO REPORT FOLDER
    if ( $PSBoundParameters.ContainsKey('PassThru') ) { Write-Output $Folder }
}