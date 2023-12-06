function ConvertTo-Hex {
    <#
    .SYNOPSIS
        Convert Char to Hex
    .DESCRIPTION
        Convert character (System.Char) to hexidecimal
    .PARAMETER Character
        Character (Char)
    .INPUTS
        System.Char.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        Name:     ConvertTo-Hex
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-10-20
        - 0.1.0 - Initial version

        Comments: <Comment(s)>
        TO CONVERT FROM HEX TO CHAR USE THE CODE BELOW
        [System.Char] 0x21
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0, HelpMessage = 'Character')]
        #[ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.json" })]
        [System.Char[]] $Character
    )
    Begin {
        # OUTPUT VERBOSE MESSAGE
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # LOOP ALL INPUT
        foreach ($char in $Character) {

            # CONVERT CHARACTER (CHAR) TO HEX
            [PSCustomObject] @{
                Char = $char
                Hex  = '0x{0:X2}' -f [int]([byte][char]$char)
            }
        }
    }
}
