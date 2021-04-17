function Convert-Epoch {
    <# =========================================================================
    .SYNOPSIS
        Convert epoch to date/time
    .DESCRIPTION
        Convert epoch to date/time
    .PARAMETER Seconds
        Epoch Time in seconds
    .PARAMETER Milliseconds
        Epoch Time in milliseconds
    .PARAMETER Time
        DateTime object
    .INPUTS
        System.Int64.
        System.DateTime.
    .OUTPUTS
        System.DateTime.
        System.Int64.
    .EXAMPLE
        PS C:\> Convert-Epoch -Seconds 1618614176
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
        [Int64] $Milliseconds, # 1618614176000

        [Parameter(Mandatory, Position = 0, ParameterSetName = '__date', ValueFromPipeline, HelpMessage = 'DateTime object')]
        [ValidateNotNullOrEmpty()]
        [datetime] $Time
    )
    Process {
        if ($PSBoundParameters.ContainsKey('Seconds')) {
            [System.DateTimeOffset]::FromUnixTimeSeconds($Seconds).DateTime.ToLocalTime()
        }
        elseif ($PSBoundParameters.ContainsKey('Milliseconds')) {
            [System.DateTimeOffset]::FromUnixTimeMilliseconds($Milliseconds).DateTime.ToLocalTime()
        }
        elseif ($PSBoundParameters.ContainsKey('Time')) {
            [PSCustomObject] @{
                Date         = $Time
                Seconds      = [System.DateTimeOffset]::new($Time).ToUnixTimeSeconds()
                Milliseconds = [System.DateTimeOffset]::new($Time).ToUnixTimeMilliseconds()
            }
        }
    }
}