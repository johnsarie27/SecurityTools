function Convert-TimeZone {
    <# =========================================================================
    .SYNOPSIS
        Convert US time zones
    .DESCRIPTION
        Convert US and UTC time zones
    .PARAMETER Time
        Time to convert
    .PARAMETER SourceTimeZone
        Time zone of Time parameter (defaults to local)
    .PARAMETER TargetTimeZone
        Time zone of desired conversion (default is UTC)
    .INPUTS
        System.String[].
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Convert-TimeZone -Time "2019-06-01 10:00 PM" -Source UTC -Target Eastern
        Convert "2019-06-01 10:00 PM" from UTC to Eastern time zone.
    .NOTES
        [DateTime]::UtcNow
        $DateTimeObject.ToLocalTime()
        $DateTimeObject.ToUniversalTime()
    ========================================================================= #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'Time to convert')] #Mandatory,
        [ValidateScript( { [System.DateTime]::Parse($_) })]
        [string[]] $Time = (Get-Date),

        [Parameter(HelpMessage = 'Source time zone (default is local)')]
        #[ValidateScript({ (Get-TimeZone -ListAvailable | Where-Object DisplayName -Match '\(US').Id })]
        [ValidateSet('Local', 'UTC', 'Pacific', 'Mountain', 'Central', 'Eastern', 'GMT')]
        [Alias('Source')]
        [string] $SourceTimeZone = 'Local',

        [Parameter(Mandatory, HelpMessage = 'Target time zone (default is UTC)')]
        #[ValidateScript({ (Get-TimeZone -ListAvailable | Where-Object DisplayName -Match '\(US').Id })]
        [ValidateSet('Local', 'UTC', 'Pacific', 'Mountain', 'Central', 'Eastern', 'GMT')]
        [Alias('Target')]
        [string] $TargetTimeZone = 'UTC'
    )

    Begin {
        # FIND OS
        if ( $PSVersionTable.PSVersion.Major -lt 6 ) { $Windows = $true }

        # FIND TIME ZONE
        if ( $IsWindows -or $Windows ) {
            $TimeZoneHash = @{
                Local    = Get-TimeZone
                UTC      = Get-TimeZone -Id 'UTC'
                Pacific  = Get-TimeZone -Id 'Pacific Standard Time'
                Mountain = Get-TimeZone -Id 'Mountain Standard Time'
                Central  = Get-TimeZone -Id 'Central Standard Time'
                Eastern  = Get-TimeZone -Id 'Eastern Standard Time'
                GMT      = Get-TimeZone -Id 'GMT Standard Time'
            }
        }
        elseif ( $IsMacOS -or $IsLinux ) {
            $TimeZoneHash = @{
                Local    = Get-TimeZone
                UTC      = Get-TimeZone -Id 'UTC'
                Pacific  = Get-TimeZone -Id 'America/Los_Angeles'
                Mountain = Get-TimeZone -Id 'America/Denver'
                Central  = Get-TimeZone -Id 'America/Chicago'
                Eastern  = Get-TimeZone -Id 'America/New_York'
                GMT      = Get-TimeZone -Id 'Europe/London'
            }
        }

        $Source = $TimeZoneHash[$SourceTimeZone]
        $Target = $TimeZoneHash[$TargetTimeZone]
    }

    Process {
        # LOOP ALL TIME ARGUMENTS
        foreach ( $t in $Time ) {
            # CONVERT ARGUMENTS TO PROPER DATA TYPES
            $OldTime = Get-Date -Date $t

            # SETUP RESULTS HASHTABLE
            $New = @{ $SourceTimeZone = $OldTime }

            # CONVERT SOURCE TO UTC
            $New.UTC = [System.TimeZoneInfo]::ConvertTimeToUtc($OldTime, $Source)

            # CONVERT UTC TO TARGET
            $New[$TargetTimeZone] = [System.TimeZoneInfo]::ConvertTime($New.UTC, $Target)

            # RETURN RESULT
            [PSCustomObject] $New
        }
    }
}
