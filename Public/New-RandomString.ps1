function New-RandomString {
    <#
    .SYNOPSIS
        Get random string
    .DESCRIPTION
        Generate a random string
    .PARAMETER Length
        String length (default of 8 characters)
    .PARAMETER ExcludeCharacter
        Exclude specified character
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
        PS C:\> New-RandomString -Length 20
        Generates a random string of 20 characters
    .NOTES
        Name:     New-RandomString
        Author:   Justin Johns
        Version:  0.1.4 | Last Edit: 2023-11-17
        - 0.1.4 - Using Get-SecureRandom for PS 7.4.0 or above
        - 0.1.3 - (2023-11-03) Renamed function to use the proper verb
        - 0.1.2 - Fixed special character set
        - 0.1.1 - Updated comments
        - 0.1.0 - Initial version

        General notes:
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-random?view=powershell-7.4
        https://learn.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Get-SecureRandom?view=powershell-7.4
    #>
    [CmdletBinding()]
    [Alias('Get-RandomString')]
    Param(
        [Parameter(HelpMessage = 'String length')]
        [System.Int32] $Length = 8,

        [Parameter(HelpMessage = 'Exclude specified character')]
        [System.String[]] $ExcludeCharacter,

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
            nums = 0x30..0x39 # NUMBERS
            lowr = 0x61..0x7A # LOWER-CASE
            uppr = 0x41..0x5A # UPPER-CASE
            #spcl = 0x21..0x7E # EVERYTHING (INCLUDING SPECIAL)
            #spc1 = 0x21..0x2F # SPECIAL CHARS SET 1
            #spc2 = 0x3A..0x40 # SPECIAL CHARS SET 2
            #spc3 = 0x5B..0x60 # SPECIAL CHARS SET 3
            #spc4 = 0x7B..0x7E # SPECIAL CHARS SET 4
            spcl = 0x21..0x2F + 0x3A..0x40 + 0x5B..0x60 + 0x7B..0x7E # SPECIAL
        }

        # REMOVE CHARACTER SETS
        if ($PSBoundParameters.ContainsKey('ExcludeNumber')) { $allSets.Remove('nums')  }
        if ($PSBoundParameters.ContainsKey('ExcludeLowercase')) { $allSets.Remove('lowr')  }
        if ($PSBoundParameters.ContainsKey('ExcludeUppercase')) { $allSets.Remove('uppr')  }
        if ($PSBoundParameters.ContainsKey('ExcludeSpecial')) { $allSets.Remove('spcl')  }

        # SET CHARACTER SET
        [System.Collections.Generic.List[System.Char]] $charSet = foreach ($s in $allSets.GetEnumerator()) { $allSets[$s.Key] }

        # REMOVE EXCLUDED CHARACTERS
        foreach ($i in $ExcludeCharacter) { $charSet.Remove($i) | Out-Null }
    }
    Process {
        # THIS ONLY USES EACH CHARACTER FROM $charSet ONCE
        #$chars = $charSet | Get-Random -Count $Length | ForEach-Object { [System.Char] $_ }

        # PS 7.4.0 INTRODUCED A
        $chars = if ($PSVersionTable.PSVersion -GE ([System.Version] '7.4.0')) {
            # "Get-SecureRandom" GENERATES CRYPTOGRAPHICALLY SECURE RANDOMNESS AND USES THE RandomNumverGenerator CLASS
            Write-Verbose -Message 'Using cryptographically secure random generator...'
            for ($i = 1; $i -LE $Length; $i++) { [System.Char] (Get-SecureRandom -InputObject $charSet -Count 1) }
        }
        else {
            # "Get-Random" DOES NOT ENSURE CRYPTOGRAPHICALLY SECURE RANDOMNESS
            Write-Warning -Message 'Older version of PowerShell detected. It is recommended to use PS 7.4.0 or newer to ensure cryptographically secure randomness.'
            for ($i = 1; $i -LE $Length; $i++) { [System.Char] (Get-Random -InputObject $charSet -Count 1) }
        }
        -join $chars
    }
}
