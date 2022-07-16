function Convert-Hexadecimal {
    <# =========================================================================
    .SYNOPSIS
        Convert hexadeciaml
    .DESCRIPTION
        Convert from hexadecimal to decimal or decimal to hexadecimal
    .PARAMETER Hexadecimal
        Hexadecimal value to convert to decimal
    .PARAMETER Decimal
        Decimal value to convert to hexadecimal
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Convert-Hexadecimal 4248
        Converts decimal value of 4248 to hexadecimal value
    .NOTES
        Name:     Convert-Hexadecimal
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-07-16
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = '__dcm')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Hexadecimal value', ParameterSetName = '__hex')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Hexadecimal,

        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Decimal value', ParameterSetName = '__dcm')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Decimal
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {

        switch ($PSCmdlet.ParameterSetName) {
            '__hex' {
                # CONVERT HEXADECIMAL TO DECIMAL
                #'{0:d}' -f 0x1098
                #[System.String]::Format('{0:d}', 0x7C2)
                [System.Convert]::ToString($Hexadecimal, 10)
            }
            '__dcm' {
                # CONVERT DECIMAL TO HEXADECIMAL
                #'{0:X}' -f 4248
                #[System.String]::Format('{0:X}', 4248)
                ('0x{0}' -f ([System.Convert]::ToString($Decimal, 16)))
            }
        }
    }
}