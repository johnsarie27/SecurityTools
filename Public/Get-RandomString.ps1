function Get-RandomString {
    <# =========================================================================
    .SYNOPSIS
        Get random string
    .DESCRIPTION
        Generate a random string
    .PARAMETER Length
        String length (default of 8 characters)
    .PARAMETER ExcludeNumber
        Exclude numbers
    .PARAMETER ExcludeLowercase
        Exclude lowercase letters
    .PARAMETER ExcludeUppercase
        Exclude uppercase letters
    .PARAMETER ExcludeSpecial
        Exclude special characters
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-RandomString -Length 20
        Generates a random string of 20 characters
    .NOTES
        General notes
        This function was taken from Marcus Gelderman (see link below)
        Some modifications have been made for code clarity
        https://gist.github.com/marcgeld/4891bbb6e72d7fdb577920a6420c1dfb
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'String length')]
        [System.Int32] $Length = 8,

        [Parameter(HelpMessage = 'Exclude numbers')]
        [System.Management.Automation.SwitchParameter] $ExcludeNumber,

        [Parameter(HelpMessage = 'Exclude lowercase letters')]
        [System.Management.Automation.SwitchParameter] $ExcludeLowercase,

        [Parameter(HelpMessage = 'Exclude uppercase letters')]
        [System.Management.Automation.SwitchParameter] $ExcludeUppercase,

        [Parameter(HelpMessage = 'Exclude special characters')]
        [System.Management.Automation.SwitchParameter] $ExcludeSpecial
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # CHECK FOR VALID PARAMETERS
        if ($ExcludeNumber -AND $ExcludeLowercase -AND $ExcludeUppercase -AND $ExcludeSpecial) {
            Write-Error -Message 'Must include at least one character set for string' -ErrorAction Stop
        }

        # SET ALL SETS
        $allSets = @{
            nums = 0x30..0x39
            lowr = 0x61..0x7A
            uppr = 0x41..0x5A
            spcl = 0x21..0x7E
        }

        # REMOVE CHARACTER SETS
        if ($PSBoundParameters.ContainsKey('ExcludeNumber')) { $allSets.Remove('nums')  }
        if ($PSBoundParameters.ContainsKey('ExcludeLowercase')) { $allSets.Remove('lowr')  }
        if ($PSBoundParameters.ContainsKey('ExcludeUppercase')) { $allSets.Remove('uppr')  }
        if ($PSBoundParameters.ContainsKey('ExcludeSpecial')) { $allSets.Remove('spcl')  }

        # SET CHARACTER SET
        $charSet = foreach ($s in $allSets.GetEnumerator()) { $allSets[$s.Key] }
    }
    Process {
        $chars = Get-Random -InputObject $charSet -Count $Length | ForEach-Object { [char]$_ }

        -join $chars

        #Write-Output ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count $length | ForEach-Object { [char]$_ }) )
    }
}