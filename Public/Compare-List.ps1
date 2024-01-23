function Compare-List {
    <#
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
        PS C:\> Compare-List -FilePath C:\List.csv
    .EXAMPLE
        PS C:\> Compare-List -ListA $ListA -ListB $ListB
    .NOTES
        Remove $compSheet section and have use Import-Csv with two lists?
    #>
    [CmdletBinding(DefaultParameterSetName = "__list")]
    [OutputType([System.Collections.Generic.List`1[System.Object]])]
    [Alias('Compare-Lists')]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "__file", HelpMessage = 'Path to CSV file containing lists')]
        [ValidateScript({ Test-Path $_ -PathType 'Leaf' -Include "*.csv" })]
        [Alias('FilePath', 'File', 'Data', 'DataFile')]
        [System.String] $Path,

        [Parameter(Mandatory = $true, ParameterSetName = "__list", HelpMessage = 'First list for comparisson')]
        [ValidateNotNullOrEmpty()]
        [Alias('List1', 'A')]
        [System.Object[]] $ListA,

        [Parameter(Mandatory = $true, ParameterSetName = "__list", HelpMessage = 'Second list for comparisson')]
        [ValidateNotNullOrEmpty()]
        [Alias('List2', 'B')]
        [System.Object[]] $ListB
    )
    Begin {
        # CREATE RESULTS COLLECTION
        $results = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        if ( $PSCmdlet.ParameterSetName -eq '__file' ) {
            # GET CSV DATA
            $compSheet = Import-Csv -Path $Path

            # CREATE WORKING LISTS
            $sameList = @() ; $header1List = @() ; $header2List = @()

            $headers = $compSheet | Get-Member -MemberType NoteProperty
            if ( ($headers | Measure-Object).Count -ne 2 ) { Write-Warning 'CSV must contain only 2 colums'; Break }
            else {
                $header1 = $headers | Select-Object -First 1 -ExpandProperty Name
                $header2 = $headers | Select-Object -Last 1 -ExpandProperty Name
            }

            # NEED TO USE SELECT-OBJECT RATHER THAN $compSheet."$header1" BECAUSE OF THE HEADER "ITEM."
            # THIS SEEMS TO CALL A METHOD OR PROPERTY OF A PSCustomObject I WASN'T PREVIOUSLY AWARE OF
            foreach ( $i in ($compSheet | Select-Object -EXP $header1) ) {
                if ( ($compSheet | Select-Object -EXP $header2) -contains $i ) { $sameList += $i }
                else { $header1List += $i }
            }
            foreach ( $i in ($compSheet | Select-Object -EXP $header2) ) {
                if ( ($compSheet | Select-Object -EXP $header1) -notcontains $i ) { $header2List += $i }
            }

            if ( $sameList.Count -gt $header1List.Count ) { $longest = $sameList }
            else { $longest = $header1List }
            if ( $header2List.Count -gt $longest.Count ) { $longest = $header2List }

            for ( $i = 0; $i -lt $longest.Count; $i++ ) {
                $new = New-Object -TypeName psobject
                if ( $sameList[$i] ) { $new | Add-Member -MemberType NoteProperty -Name 'DUPLICATES' -Value $sameList[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name 'DUPLICATES' -Value '=>' }
                if ( $header1List[$i] ) { $new | Add-Member -MemberType NoteProperty -Name "$header1" -Value $header1List[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name "$header1" -Value '<>' }
                if ( $header2List[$i] ) { $new | Add-Member -MemberType NoteProperty -Name "$header2" -Value $header2List[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name "$header2" -Value '<=' }
                $results.Add($new)
            }
        }
        if ( $PSCmdlet.ParameterSetName -eq '__list' ) {
            # SETUP WORKING LISTS
            $sameList = @() ; $uniqueListA = @() ; $uniqueListB = @()

            # COMPARE LIST OBJECTS
            $listAName = 'LIST-A'; $listBName = 'LIST-B'
            foreach ( $i in $ListA ) {
                if ( $ListB -contains $i ) { $sameList += $i }
                else { $uniqueListA += $i }
            }
            foreach ( $i in $ListB ) {
                if ( $ListA -notcontains $i ) { $uniqueListB += $i }
            }

            # GET LONGEST LIST
            if ( $sameList.Count -gt $uniqueListA.Count ) { $longest = $sameList }
            else { $longest = $uniqueListA }
            if ( $uniqueListB.Count -gt $longest.Count ) { $longest = $uniqueListB }

            # CREATE AND POPULATE OUTPUT OBJECTS
            for ( $i = 0; $i -lt $longest.Count; $i++ ) {
                $new = New-Object -TypeName psobject
                if ( $sameList[$i] ) { $new | Add-Member -MemberType NoteProperty -Name 'DUPLICATES' -Value $sameList[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name 'DUPLICATES' -Value '=>' }
                if ( $uniqueListA[$i] ) { $new | Add-Member -MemberType NoteProperty -Name $listAName -Value $uniqueListA[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name $listAName -Value '<>' }
                if ( $uniqueListB[$i] ) { $new | Add-Member -MemberType NoteProperty -Name $listBName -Value $uniqueListB[$i] }
                else { $new | Add-Member -MemberType NoteProperty -Name $listBName -Value '<=' }
                $results.Add($new)
            }
        }
    }
    End {
        # RETURN RESULTS COLLECTION
        $results
    }
}
