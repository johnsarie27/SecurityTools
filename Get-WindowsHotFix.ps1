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
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'Name of target computer')]
        [ValidateScript({ Test-Connection -ComputerName $_ -Count 1 -Quiet })]
        [string[]] $ComputerName,
    
        [Parameter(HelpMessage = 'Knowledge base identifier')]
        [ValidatePattern('KB\d{7}')]
        [string[]] $Id
    )

    Begin {
        # SET PARAMETERS
        if ( $PSBoundParameters.ContainsKey('Id') ) {
            $ScriptBlock = { Get-HotFix -Id $Id }
        }
        else {
            $ScriptBlock = { Get-HotFix }
        }
    }

    Process {
        # THIS WAS A DESIGN CHOICE TO ALLOW INPUT THROUGH THE PIPELINE. WE COULD HAVE NOT ACCEPTED
        # THE INPUT THIS WAY AND PASSED AND ARRAY OF COMPUTERNAME TO INVOKE-COMMAND WHICH WOULD
        # HAVE PROVIDED THE SAME RESULT. MORE TESTING SHOULD BE DONE TO DETERMINE THE PERFORMANCE
        # IMPACT, HOWEVER, THE PIPELINE IS GENERALLY SLOWER. THIS CHOICE ALLOWS THE CALLER TO USE
        # WHATEVER METHOD THEY CHOOSE TO PASS INPUT TO THE FUNCTION.
        
        #Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock

        foreach ( $cn in $ComputerName ) {
            Invoke-Command -ComputerName $cn -ScriptBlock $ScriptBlock    
        }
    }
}