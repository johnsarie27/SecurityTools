function Get-WinInfo {
    <# =========================================================================
    .SYNOPSIS
        Get Windows information
    .DESCRIPTION
        Get Windows information using WMI and CIM
    .PARAMETER List
        List available classes
    .PARAMETER Id
        Id of class object
    .PARAMETER ComputerName
        Name of target host
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-WinInfo -List
        List available classes to pull information from
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = '__list')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'List available classes', ParameterSetName = '__list')]
        [switch] $List,

        [Parameter(Mandatory, HelpMessage = 'Class Id', ParameterSetName = '__info')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $InfoModel.Classes.Id -contains $_ })]
        [int] $Id,

        [Parameter(ValueFromPipeline, HelpMessage = 'Hostname of target computer', ParameterSetName = '__info')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [Alias('CN')]
        [string] $ComputerName
    )

    Process {
        $infoModel = Get-Content -Raw -Path "$PSScriptRoot\InformationModel.json" | ConvertFrom-Json

        switch ($PSCmdlet.ParameterSetName) {
            '__list' {
                $infoModel.Classes | Select-Object -Property Id, Comments
            }
            '__info' {
                $im = $infoModel.Classes.Where({ $_.Id -EQ $Id })

                $cimParams = @{
                    Namespace = $im.Namespace
                    ClassName = $im.ClassName
                }

                if ( $im.Filters ) { $cimParams.Add('Filter', $im.Filters) }

                if ( $PSBoundParameters.ContainsKey('ComputerName') ) { $cimParams.Add('ComputerName', $ComputerName) }

                Get-CimInstance @cimParams
            }
        }
    }
}