function Convert-SecureKey {
    <# =========================================================================
    .SYNOPSIS
        Convert string to PSCredential object or store as CliXML
    .DESCRIPTION
        This simple function will either create a PSCredential object and store it
        as XML or retrieve a PSCredential object from a Clixml file.
    .PARAMETER Path
        Path to CliXML file containing Credential object
    .PARAMETER Username
        Username
    .PARAMETER Password
        Password in SecureString type format
    .PARAMETER DestinationPath
        Path to directory for new credential file
    .PARAMETER PassThru
        Return new credential object
    .INPUTS
        None.
    .OUTPUTS
        System.PSCredential.
    .EXAMPLE
        -- EXAMPLE 1 --
        PS C:\> Convert-SecureKey -Username 'Password' -DestinationPath "$HOME\Documents\Creds.xml"
    .EXAMPLE
        -- EXAMPLE 2 --
        PS C:\> Convert-SecureKey -Path C:\Store\Credentials.xml
    .NOTES
        It appears that the Clixml file is locked to the user and computer where
        it was created. It cannot be accessed by another user or computer. The
        article below has more information based on a different Cmdlet.
        https://www.randomizedharmony.com/blog/2018/11/25/using-credentials-in-production-scripts
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = '_retrieve')]
    Param(
        [Parameter(Mandatory, ParameterSetName = '_retrieve', HelpMessage = 'Path to secure Clixml file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.xml" })]
        [string] $Path,

        [Parameter(Mandatory, ParameterSetName = '_create', HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [string] $Username,

        [Parameter(ParameterSetName = '_create', HelpMessage = 'Enter SecureString')]
        [ValidateNotNullOrEmpty()]
        [Alias('SP')]
        [SecureString] $SecurePassword,

        [Parameter(Mandatory, ParameterSetName = '_create', HelpMessage = 'Path to new credential XML file')]
        [ValidateScript({ Test-Path -Path ([System.IO.Path]::GetDirectoryName($_)) })]
        [ValidateScript({ [System.IO.Path]::GetExtension($_) -eq '.xml' })]
        [Alias('DP')]
        [string] $DestinationPath,

        [Parameter(ParameterSetName = '_create', HelpMessage = 'Return new credential object')]
        [switch] $PassThru,

        [Parameter(ParameterSetName = '_create', HelpMessage = 'Overwrite existing file')]
        [switch] $Force
    )

    Begin {
        # CREATE NEW ENCRYPTED CREDENTIAL FILE
        if ( $PSCmdlet.ParameterSetName -eq '_create' ) {
            $DestinationPath = Test-DestinationPath -Path $DestinationPath -Extension '.xml' -AllowOverwrite

            # CONFIRM PATH DOESN'T EXIST
            if ( (Test-Path -Path $DestinationPath -PathType Leaf) -and !$Force ) {
                Throw 'File already exists. Use "-Force" to overwrite.'
            }

            # IF SECURE PASSWORD NOT PROVIDED IN PARAMETERS
            if ( -not $PSBoundParameters.ContainsKey('SecurePassword') ) {
                # PROMPT USER FOR PASSWORD AS SECURE STRING
                do {
                    $SecurePassword = Read-Host -Prompt 'Enter password' -AsSecureString
                    $confirmPassword = Read-Host -Prompt 'Confirm password' -AsSecureString

                    $sP = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))
                    $cP = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPassword))

                    if ( $sp -cne $cp ) { Write-Warning 'Passwords do not match.' }
                }
                while ( $sp -cne $cp )
            }
            # $SecurePassword = 'SuperDuperPassword' | ConvertTo-SecureString -AsPlainText -Force

            # CREATE NEW CREDENTIAL OBJECT
            $Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
        }
    }
    End {
        # CREATE XML FILE AND RETURN CREDENTIAL OBJECT
        if ( $PSCmdlet.ParameterSetName -eq '_create' ) {
            # SAVE CREDENTIAL OBJECT TO CLIXML FILE
            $Credential | Export-Clixml -Path $DestinationPath

            # RETURN NEW PATH
            if ( $PSBoundParameters.ContainsKey('PassThru') ) { $Credential }
        }

        # RETRIEVE CREDENTIAL OBJECT FOR CLIXML FILE
        if ( $PSCmdlet.ParameterSetName -eq '_retrieve' ) {
            <# # DO NOT DELETE
            $Password = (Import-Clixml -Path $Path).GetNetworkCredential().Password #>

            # RETRIEVE CREDENTIAL OBJECT FROM CLIXML FILE
            $Credential = Import-Clixml -Path $Path

            # RETURN CREDENTIAL OBJECT
            $Credential
        }
    }
}
