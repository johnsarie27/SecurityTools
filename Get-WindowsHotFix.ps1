function Get-WindowsHotFix {
    <# =========================================================================
    .SYNOPSIS
        Get Windows hotfix
    .DESCRIPTION
        Get Windows hotfix applied to target system
    .PARAMETER ComputerName
        Specifies a remote computer. Type the NetBIOS name, an Internet Protocol (IP) address, or a fully qualified domain name (FQDN) of a remote computer.
    .PARAMETER Id
        Filters the Get-HotFix results for specific hotfix Ids. Wildcards aren't accepted.
    .PARAMETER Description
        Get-HotFix uses the Description parameter to specify hotfix types. Wildcards are permitted.
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-WindowsHotFix -ComputerName MyServer
        Returns all Windows Updates applied to MyServer
    .NOTES
        General notes
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-hotfix?view=powershell-5.1#parameters
        (2019-09-27) TODAY I DISCOVERED THAT THIS FUNCTIONALITY HAS BEEN ADDED TO GET-HOTFIX. I WILL REMOVE
        THIS FUNCTION FROM THE MODULE BUT KEEP THE FILE FOR HISTORICAL PURPOSES.
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'Name of target computer')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [string[]] $ComputerName,

        [Parameter(HelpMessage = 'Knowledge base identifier')]
        [ValidatePattern('KB\d{7}')]
        [string[]] $Id,

        [Parameter(HelpMessage = 'Specify hotfix type by description. Wildcards are supported')]
        [ValidateNotNullOrEmpty()]
        [string] $Description
    )

    Begin {
        # SET PARAMETERS
        $cmdParams = @{ ScriptBlock = { Get-HotFix } }

        if ( $PSBoundParameters.ContainsKey('Id') ) {
            if ( $PSBoundParameters.ContainsKey('Description') ) {
                $cmdParams['ScriptBlock'] = { Get-HotFix -Id $Using:Id -Description $Using:Description }
            }
            else {
                $cmdParams['ScriptBlock'] = { Get-HotFix -Id $Using:Id }
            }
        }
        if ( $PSBoundParameters.ContainsKey('Description') -and -not $PSBoundParameters.ContainsKey('Id') ) {
            $cmdParams['ScriptBlock'] = { Get-HotFix -Description $Using:Description }
        }

        # WRITE PARAMETERS WHEN -VERBOSE IS USED
        Write-Verbose ('Parameters: {0}' -f ($cmdParams | Out-String))
    }

    Process {
        # THIS WAS A DESIGN CHOICE TO ALLOW INPUT THROUGH THE PIPELINE. WE COULD HAVE NOT ACCEPTED
        # THE INPUT THIS WAY AND PASSED AND ARRAY OF COMPUTERNAME TO INVOKE-COMMAND WHICH WOULD
        # HAVE PROVIDED THE SAME RESULT. MORE TESTING SHOULD BE DONE TO DETERMINE THE PERFORMANCE
        # IMPACT, HOWEVER, THE PIPELINE IS GENERALLY SLOWER. THIS CHOICE ALLOWS THE CALLER TO USE
        # WHATEVER METHOD THEY CHOOSE TO PASS INPUT TO THE FUNCTION.

        #Invoke-Command @cmdParams -ComputerName $ComputerName

        foreach ( $cn in $ComputerName ) {
            Invoke-Command @cmdParams -ComputerName $cn
        }
    }
}