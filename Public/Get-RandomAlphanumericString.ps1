function Get-RandomAlphanumericString {
    <# =========================================================================
    .SYNOPSIS
        Get random alphanumeric string
    .DESCRIPTION
        Generate a random alphanumeric string
    .PARAMETER Length
        String length (default of 8 characters)
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-RandomAlphanumericString -Length 20
        Generates a random alphanumeric string of 20 characters
    .NOTES
        General notes
        This function was taken from Marcus Gelderman (see link below)
        Some modifications have been made for code clarity
        https://gist.github.com/marcgeld/4891bbb6e72d7fdb577920a6420c1dfb
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'String length')]
        [System.Int32] $Length = 8
    )

    Process {
        $charSet = @( 0x30..0x39 + 0x41..0x5A + 0x61..0x7A )
        #$charSet = @( 0x21..0x7E ) # INCLUDES SPECIAL CHARS

        $chars = Get-Random -InputObject $charSet -Count $Length | ForEach-Object { [char]$_ }

        -join $chars

        #Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count $length | ForEach-Object { [char]$_ }) )
    }
}