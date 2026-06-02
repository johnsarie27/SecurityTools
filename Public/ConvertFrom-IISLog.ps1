function ConvertFrom-IISLog {
    <#
    .SYNOPSIS
        Convert from IIS log
    .DESCRIPTION
        Convert from IIS log to objects
    .PARAMETER Path
        Path to IIS log file
    .INPUTS
        System.String.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> ConvertFrom-IISLog -Path C:\logs\myLog.log
        Converts log data into objects
    .NOTES
        Status: Stable
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Path to IIS log file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.log" })]
        [System.String] $Path
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {

        # PROCESS EACH LINE
        foreach ($line in (Get-Content -Path $Path)) {

            # GET HEADERS
            if ($line.StartsWith('#Fields:')) {

                # SET HEADERS
                $headers = $line.Replace('#Fields: ', '').Split(' ')
            }
            # CREATE OBJECTS FROM DATA ROWS
            if ($line -NotMatch '^#') {

                # SPLIT LINE
                $split = $line.Split(' ')

                # CREATE HASHTABLE
                $hash = [Ordered] @{}

                # ADD PROPERTY NAME AND VALUE TO HASHTABLE
                for ($i = 0; $i -LT $headers.Count; $i++) { $hash.Add($headers[$i], $split[$i]) }

                # CAST HASHTABLE AS OBJECT AND OUTPUT
                [PSCustomObject] $hash
            }
        }
    }
}