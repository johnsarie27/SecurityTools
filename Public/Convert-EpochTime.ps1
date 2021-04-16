function ConvertFrom-EpochTime {
    <# =========================================================================
    .SYNOPSIS
        Convert epoch to date/time
    .DESCRIPTION
        Convert epoch to date/time
    .PARAMETER Seconds
        Epoch Time in seconds
    .PARAMETER Milliseconds
        Epoch Time in milliseconds
    .INPUTS
        System.Int64.
    .OUTPUTS
        System.Int64.
    .EXAMPLE
        PS C:\> ConvertFrom-EpochTime -Seconds 1618614176
        Converts epoch time to date/time object
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = '__sec')]
    Param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = '__sec', ValueFromPipeline, HelpMessage = 'EPOCH Time in seconds')]
        [ValidateNotNullOrEmpty()]
        [Int64] $Seconds, # 1618614176

        [Parameter(Mandatory, Position = 0, ParameterSetName = '__ms', ValueFromPipeline, HelpMessage = 'EPOCH Time in milliseconds')]
        [ValidateNotNullOrEmpty()]
        [Int64] $Milliseconds # 1618614176000
    )
    Process {
        if ($PSBoundParameters.ContainsKey('Seconds')) {
            [System.DateTimeOffset]::FromUnixTimeSeconds($Seconds).DateTime.ToLocalTime()
        }
        elseif ($PSBoundParameters.ContainsKey('Milliseconds')) {
            [System.DateTimeOffset]::FromUnixTimeMilliseconds($Milliseconds).DateTime.ToLocalTime()
        }
    }
}