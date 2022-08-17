function ConvertTo-FlatObject {
    <# =========================================================================
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER Path
        Parameter description (if any)
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        Name:     ConvertTo-FlatObject
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-08-17
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://powersnippets.com/convertto-flatobject/
        https://github.com/EvotecIT/PSSharedGoods/blob/master/Public/Converts/ConvertTo-FlatObject.ps1
        https://github.com/RamblingCookieMonster/PowerShell/blob/master/ConvertTo-FlatObject.ps1
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeLine, HelpMessage = 'Object to convert')]
        [System.Object[]] $Object,

        [Parameter(HelpMessage = 'Separator character')]
        [System.String] $Separator = ".",

        [Parameter(HelpMessage = 'Base')]
        [ValidateSet("", 0, 1)]
        $Base = 1,

        [Parameter(HelpMessage = 'Depth')]
        [System.Int16] $Depth = 5,

        [Parameter(HelpMessage = 'Property to exclude')]
        [System.String[]] $ExcludeProperty,

        [Parameter(DontShow)]
        [System.String[]] $Path,

        [Parameter(DontShow)]
        [System.Collections.IDictionary] $OutputObject
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        $InputObjects = [System.Collections.Generic.List[Object]]::new()
    }
    Process {
        foreach ($o in $Object) { if ($null -ne $o) { $InputObjects.Add($o) } }
    }
    End {
        If ($PSBoundParameters.ContainsKey("OutputObject")) {
            $obj = $InputObjects[0]
            $Iterate = [ordered] @{}
            if ($null -eq $obj) {
                #Write-Verbose -Message "ConvertTo-FlatObject - Object is null"
            }
            elseif ($obj.GetType().Name -in 'String', 'DateTime', 'TimeSpan', 'Version', 'Enum') {
                $obj = $obj.ToString()
            }
            elseif ($Depth) {
                $Depth--
                If ($obj -is [System.Collections.IDictionary]) {
                    $Iterate = $obj
                }
                elseif ($obj -is [Array] -or $obj -is [System.Collections.IEnumerable]) {
                    $i = $Base
                    foreach ($Item in $obj.GetEnumerator()) {
                        $NewObject = [ordered] @{}
                        If ($Item -is [System.Collections.IDictionary]) {
                            foreach ($Key in $Item.Keys) {
                                if ($Key -notin $ExcludeProperty) {
                                    $NewObject[$Key] = $Item[$Key]
                                }
                            }
                        }
                        elseif ($Item -isnot [Array] -and $Item -isnot [System.Collections.IEnumerable]) {
                            foreach ($Prop in $Item.PSObject.Properties) {
                                if ($Prop.IsGettable -and $Prop.Name -notin $ExcludeProperty) {
                                    $NewObject["$($Prop.Name)"] = $Item.$($Prop.Name)
                                }
                            }
                        }
                        else {
                            $NewObject = $Item
                        }
                        $Iterate["$i"] = $NewObject
                        $i += 1
                    }
                }
                else {
                    foreach ($Prop in $obj.PSObject.Properties) {
                        if ($Prop.IsGettable -and $Prop.Name -notin $ExcludeProperty) {
                            $Iterate["$($Prop.Name)"] = $obj.$($Prop.Name)
                        }
                    }
                }
            }
            If ($Iterate.Keys.Count) {
                foreach ($Key in $Iterate.Keys) {
                    if ($Key -notin $ExcludeProperty) {
                        ConvertTo-FlatObject -Object @(, $Iterate["$Key"]) -Separator $Separator -Base $Base -Depth $Depth -Path ($Path + $Key) -OutputObject $OutputObject -ExcludeProperty $ExcludeProperty
                    }
                }
            }
            else {
                $Property = $Path -Join $Separator
                if ($Property) {
                    # We only care if property is not empty
                    if ($obj -is [System.Collections.IDictionary] -and $obj.Keys.Count -eq 0) {
                        $OutputObject[$Property] = $null
                    }
                    else {
                        $OutputObject[$Property] = $obj
                    }
                }
            }
        }
        elseif ($InputObjects.Count -gt 0) {
            foreach ($ItemObject in $InputObjects) {
                $OutputObject = [ordered] @{}
                ConvertTo-FlatObject -Object @(, $ItemObject) -Separator $Separator -Base $Base -Depth $Depth -Path $Path -OutputObject $OutputObject -ExcludeProperty $ExcludeProperty
                [PSCustomObject] $OutputObject
            }
        }
    }
}