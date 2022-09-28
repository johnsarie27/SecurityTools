function ConvertTo-MarkdownTable {
    <# =========================================================================
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER InputObject
        Input object
    .INPUTS
        System.Object.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        Name:     ConvertTo-MarkDownTable
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-09-28
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://stackoverflow.com/questions/69010143/convert-powershell-output-to-a-markdown-file
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Input object')]
        [ValidateNotNullOrEmpty()]
        [System.Object] $InputObject
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        $headersDone = $false
        $pattern = '(?<!\\)\|'  # escape every '|' unless already escaped
    }
    Process {
        if (!$headersDone) {
            $headersDone = $true
            # output the header line and below that a dashed line
            # -replace '(?<!\\)\|', '\|' escapes every '|' unless already escaped
            '|{0}|' -f (($_.PSObject.Properties.Name -replace $pattern, '\|') -join '|')
            '|{0}|' -f (($_.PSObject.Properties.Name -replace '.', '-') -join '|')
        }
        '|{0}|' -f (($_.PsObject.Properties.Value -replace $pattern, '\|') -join '|')
    }
}