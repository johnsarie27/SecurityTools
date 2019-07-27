function Compare-Lists {
    <# =========================================================================
    .SYNOPSIS
        Compare 2 lists as input objects or in a CSV file.
    .DESCRIPTION
        This function will accept a file path parameter for a csv file or two lists
        of the same object type. The script will then validate the file has only 2
        columns and output the similarities and differences in each lists. If 2
        lists are provided, it will validate the object types are equal.
    .PARAMETER Path
        Path to a CSV file containing only two columns of strings to
        be compared to each other. This parameter should be used alone, not in
        conjunction with the List parameters.
    .PARAMETER ListA
        First list of objects for comparisson
    .PARAMETER ListB
        Second list which will be compared to the first
    .INPUTS
        System.Object.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Compare-Lists -FilePath C:\List.csv
    .EXAMPLE
        PS C:\> Compare-Lists -ListA $ListA -ListB $ListB
    .NOTES
        Remove $CompSheet section and have use Import-Csv with two lists?
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = "__list")]
    [OutputType([System.Collections.Generic.List`1[System.Object]])]

    Param(
        [Parameter(Mandatory, ParameterSetName = "__file", HelpMessage = 'Path to CSV file containing lists')]
        [ValidateScript( {Test-Path $_ -PathType 'Leaf' -Include "*.csv"})]
        [Alias('FilePath', 'File', 'Data', 'DataFile')]
        [String] $Path,

        [Parameter(Mandatory, ParameterSetName = "__list", HelpMessage = 'First list for comparisson')]
        [ValidateNotNullOrEmpty()]
        [Alias('List1', 'A')]
        [System.Object[]] $ListA,

        [Parameter(Mandatory, ParameterSetName = "__list", HelpMessage = 'Second list for comparisson')]
        [ValidateNotNullOrEmpty()]
        [Alias('List2', 'B')]
        [System.Object[]] $ListB
    )

    Begin {
        # CREATE RESULTS COLLECTION
        $Results = [System.Collections.Generic.List[System.Object]]::new()
    }

    Process {
        if ( $PSCmdlet.ParameterSetName -eq '__file' ) {
            # GET CSV DATA
            $CompSheet = Import-Csv -Path $Path

            # CREATE WORKING LISTS
            $SameList = @() ; $Header1List = @() ; $Header2List = @()

            $Headers = $CompSheet | Get-Member -MemberType NoteProperty
            if ( ($Headers | Measure-Object).Count -ne 2 ) { Write-Warning 'CSV must contain only 2 colums'; Break }
            else {
                $Header1 = $Headers | Select-Object -First 1 -ExpandProperty Name
                $Header2 = $Headers | Select-Object -Last 1 -ExpandProperty Name
            }

            # NEED TO USE SELECT-OBJECT RATHER THAN $CompSheet."$Header1" BECAUSE OF THE HEADER "ITEM."
            # THIS SEEMS TO CALL A METHOD OR PROPERTY OF A PSCustomObject I WASN'T PREVIOUSLY AWARE OF
            foreach ( $i in ($CompSheet | Select-Object -EXP $Header1) ) {
                if ( ($CompSheet | Select-Object -EXP $Header2) -contains $i ) { $SameList += $i }
                else { $Header1List += $i }
            }
            foreach ( $i in ($CompSheet | Select-Object -EXP $Header2) ) {
                if ( ($CompSheet | Select-Object -EXP $Header1) -notcontains $i ) { $Header2List += $i }
            }

            if ( $SameList.Count -gt $Header1List.Count ) { $Longest = $SameList }
            else { $Longest = $Header1List }
            if ( $Header2List.Count -gt $Longest.Count ) { $Longest = $Header2List }

            for ( $i = 0; $i -lt $Longest.Count; $i++ ) {
                $new = New-Object -TypeName psobject
                if ( $SameList[$i] ) { $new | Add-Member -MemberType NoteProperty -Name 'DUPLICATES' -Value $SameList[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name 'DUPLICATES' -Value '=>' }
                if ( $Header1List[$i] ) { $new | Add-Member -MemberType NoteProperty -Name "$Header1" -Value $Header1List[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name "$Header1" -Value '<>' }
                if ( $Header2List[$i] ) { $new | Add-Member -MemberType NoteProperty -Name "$Header2" -Value $Header2List[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name "$Header2" -Value '<=' }
                $Results.Add($new)
            }
        }

        if ( $PSCmdlet.ParameterSetName -eq '__list' ) {
            # SETUP WORKING LISTS
            $SameList = @() ; $UniqueListA = @() ; $UniqueListB = @()

            # COMPARE LIST OBJECTS
            $ListAName = 'LIST-A'; $ListBName = 'LIST-B'
            foreach ( $i in $ListA ) {
                if ( $ListB -contains $i ) { $SameList += $i }
                else { $UniqueListA += $i }
            }
            foreach ( $i in $ListB ) {
                if ( $ListA -notcontains $i ) { $UniqueListB += $i }
            }

            # GET LONGEST LIST
            if ( $SameList.Count -gt $UniqueListA.Count ) { $Longest = $SameList }
            else { $Longest = $UniqueListA }
            if ( $UniqueListB.Count -gt $Longest.Count ) { $Longest = $UniqueListB }

            # CREATE AND POPULATE OUTPUT OBJECTS
            for ( $i = 0; $i -lt $Longest.Count; $i++ ) {
                $new = New-Object -TypeName psobject
                if ( $SameList[$i] ) { $new | Add-Member -MemberType NoteProperty -Name 'DUPLICATES' -Value $SameList[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name 'DUPLICATES' -Value '=>' }
                if ( $UniqueListA[$i] ) { $new | Add-Member -MemberType NoteProperty -Name $ListAName -Value $UniqueListA[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name $ListAName -Value '<>' }
                if ( $UniqueListB[$i] ) { $new | Add-Member -MemberType NoteProperty -Name $ListBName -Value $UniqueListB[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name $ListBName -Value '<=' }
                $Results.Add($new)
            }
        }

        # RETURN RESULTS COLLECTION
        $Results
    }
}