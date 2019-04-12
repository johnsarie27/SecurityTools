function ConvertTo-DbScanReport {
    <# =========================================================================
    .SYNOPSIS
        Format JSON output from SQL DB scan report
    .DESCRIPTION
        Long description
    .PARAMETER ReportPath
        Path to SQL scan output JSON file
    .PARAMETER BaselinePath
        Path to baseline Excel file
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ChildItem -Path $Folder | ConvertTo-DbScanReport -BaselinePath $Path
        Combine and format all reports in $Folder using baseline $Path
    .NOTES
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Parent folder of db scan report(s)')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.json" })]
        [Alias('Report', 'RP')]
        [string[]] $ReportPath,

        [Parameter(Mandatory, HelpMessage = 'Master baseline file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.xlsx" })]
        [Alias('Baseline', 'BP')]
        [string] $BaselinePath
    )

    Begin {
        # IMPORT MODULES
        Import-Module ImportExcel

        # GET BASELINE OBJECTS
        $Baseline = Import-Excel -Path $BaselinePath

        # CREATE LIST
        $Results = @()
    }

    Process {
        # LOOP THROUGH FILES
        foreach ( $File in $ReportPath ) {
            
            # CONVERT FILE TO JSON
            $DBReport = Get-Content -Path $File | ConvertFrom-Json
        
            # LOOP THROUGH FINDINGS
            foreach ( $find in ($DBReport.Scans.Results | Where-Object Status -EQ 'Finding') ) {

                # CREATE NEW OBJECT
                $New = @{
                    Database = (Split-Path -Path $File -Leaf) -Replace '^([a-z0-9-]+)_.+', '$1'
                    RuleId = $find.RuleId
                    Finding = $find.Status
                    #QueryResults = $find.QueryResults       # THIS APPEARS TO BE MULTIPLE STRINGS AND THEREFORE AN ARRAY OBJECT
                    RemediationDescription = $find.Remediation.Description
                    RemediationScript = $find.Remediation.Script        # RemediationAutomated, RemediationPortalLink
                    #BaselineAdjustedResult = $find.BaselineAdjustedResult
                }

                # ADD INFO FROM RULES
                $RuleId = $find.RuleId
                $New.Severity = $DBReport.Scans.Rules.$RuleId.Severity
                #$New.Category = $DBReport.Scans.Rules.$RuleId.Category
                #$New.RuleType = $DBReport.Scans.Rules.$RuleId.RuleType
                $New.Description = $DBReport.Scans.Rules.$RuleId.Description
                $New.Name = $DBReport.Scans.Rules.$RuleId.Title
                $New.Rationale = $DBReport.Scans.Rules.$RuleId.Rationale

                # ADD INFO FROM BASELINE
                if ( $Baseline.ID -contains $RuleId ) {
                    $New.Status = 'Inactive'
                    $New.Baseline = ($Baseline | Where-Object ID -EQ $RuleId).'Baseline Justification'
                } else {
                    $New.Status = 'Active'
                    $New.Baseline = ''    
                }

                # ADD TO LIST
                $Results += [PSCustomObject] $New
            }
        }
    }

    End {
        # PROPERTY ORDER
        $Props = @(
            'Database'
            'RuleId'
            'Finding'
            'Severity'
            'Name'
            'Description'
            'Status'
            'Baseline'
            'Rationale'
            'RemediationDescription'
            'RemediationScript'
        )

        # RETURN
        $Results | Select-Object -Property $Props
    }
}
