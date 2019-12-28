function Get-Object {
    <# =========================================================================
    .SYNOPSIS
        Choose an object from list of objects
    .DESCRIPTION
        This function displays the list of given objects, promts the user to
        select one, and returns the selected object.
    .PARAMETER ObjectList
        List of objects to choose from. The list should contain objects of the
        same type.
    .PARAMETER DisplayProperty
        This is the Property or NoteProperty representing the list of objects
        to display to the user.
    .PARAMETER String
        Use this switch parameter if the object list is of type String.
    .PARAMETER Index
        Using this switch parameter will return the object index rather than
        the object itself.
    .INPUTS
        System.Object.
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-Object -ObjectList $Computers -MemberType 'NoteProperty' `
        -DisplayProperty 'Name'
    .NOTES
        Write-Host -
        https://www.jsnover.com/blog/2013/12/07/write-host-considered-harmful/
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = "object")]
    Param(
        [Parameter(Mandatory, HelpMessage = 'List of objects to choose from')]
        [ValidateScript( { $_.Count -gt 0 })]
        [Alias('List', 'OL')]
        [System.Object[]] $ObjectList,

        [Parameter(Mandatory, ParameterSetName = "object", HelpMessage = 'Object property to display')]
        [ValidateScript( { ($ObjectList | Get-Member).Name -contains $_ })]
        [Alias('Name', 'DP')]
        [string] $DisplayProperty,

        [Parameter(Mandatory, ParameterSetName = "string", HelpMessage = 'Object type of string')]
        [switch] $String,

        [Parameter(HelpMessage = 'Return object index instead of object')]
        [switch] $Index
    )

    Write-Host "Available objects:" ; $j = 1
    if ( $PSBoundParameters.ContainsKey('String') ) {
        $ObjectList | ForEach-Object -Process { Write-Host ('{0}. {1}' -f $j, $_); $j++ }
    }
    if ( $PSBoundParameters.ContainsKey('DisplayProperty') ) {
        $ObjectList | ForEach-Object -Process { Write-Host ('{0}. {1}' -f $j, $_."$DisplayProperty"); $j++ }
    }
    do { $Selection = Read-Host "Enter number of desired object" }
    while ( $null -eq $ObjectList.Get($Selection - 1) -OR ($Selection -eq 0) )

    if ( $Index ) { $Result = ($Selection - 1) } else { $Result = $ObjectList.Get($Selection - 1) }

    return $Result
}
