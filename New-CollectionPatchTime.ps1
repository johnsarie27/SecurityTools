function New-CollectionPatchTime {
    <# =========================================================================
    .SYNOPSIS
        Calculate new patching times in UTC
    .DESCRIPTION
        Create new object with CollectionName and deployment times in UTC using
        provided start time.
    .PARAMETER StartTime
        Start time for first collection to be patched
    .PARAMETER EndTime
        End time for last collection to be patched
    .PARAMETER TimeZone
        Time zone of StartTime argument
    .PARAMETER CollectionName
        Collection name for deployment group
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> New-CollectionPatchTime -EndTime "02/13/2019 2:00 PM" -TimeZone Eastern -CN $Collections.Name
        Create new deployment group objects for Reference starting at 2:00 PM Eastern on 02/13/2019
    .NOTES
        General notes 
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ParameterSetName='start', HelpMessage='Start time for first collection')]
        [ValidateScript( { [System.DateTime]::Parse($_) })]
        [Alias('ST')]
        [string] $StartTime,

        [Parameter(Mandatory, ParameterSetName='end', HelpMessage='End time for last collection')]
        [ValidateScript( { [System.DateTime]::Parse($_) })]
        [Alias('ET')]
        [string] $EndTime,

        [Parameter(HelpMessage='Time zone for start time')]
        [ValidateSet('Eastern', 'Pacific', 'UTC')]
        [Alias('TZ')]
        [string] $TimeZone = 'UTC',

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Collection name')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [string[]] $CollectionName
    )

    Begin {
        # IMPORT MODULES
        Import-Module -Name UtilityFunctions

        # SET VARS
        if ( $PSBoundParameters.ContainsKey('StartTime') ) { $n=0 }
        elseif ( $PSBoundParameters.ContainsKey('EndTime') ) { $n=-4 }
        $Group = @()
    }

    Process {
        # LOOP THROUGH COLLECTIONS
        $CollectionName | ForEach-Object -Process {

            if ( $PSBoundParameters.ContainsKey('StartTime') ) { $Time = (Get-Date -Date $StartTime).AddHours($n) }
            elseif ( $PSBoundParameters.ContainsKey('EndTime') ) { $Time = (Get-Date -Date $EndTime).AddHours($n) }
            
            $UTCTime = (Convert-TimeZone -Time $Time -Source $TimeZone -Target UTC).UTC

            $New = @{ CollectionName = $_ }
            if ( $_ -match 'Security' ) {
                $New.UTC = (Get-Date -Date ('{0} 05:00 AM' -f $UTCTime.ToString("yyyy-MM-dd"))).AddDays(2)
            } else {
                $New.UTC = $UTCTime
            }
            
            $Group += [PSCustomObject] $New
            $n++
        }
    }

    End {
        # RETURN
        $Group
    }
}
