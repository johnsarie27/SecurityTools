function ConvertTo-MarkdownTable {
    <# =========================================================================
    .SYNOPSIS
        Convert array of objects to Markdown table
    .DESCRIPTION
        Convert array of objects to Markdown table
    .PARAMETER InputObject
        Input object.
    .INPUTS
        System.Object.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> $svc = Get-Service | Select-Object -Property DisplayName, Name, Description
        PS C:\> $svc | Select-Object -First 5 | ConvertTo-MarkdownTable
        Converts the first 5 services to a Markdown table
    .NOTES
        Name:     ConvertTo-MarkDownTable
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-09-28
        - 0.1.0 - Initial version
        - 0.1.1 - Added spaces around text
        Comments: <Comment(s)>
        General notes:
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
            '| {0} |' -f (($_.PSObject.Properties.Name -replace $pattern, '\|') -join ' | ')
            '| {0} |' -f (($_.PSObject.Properties.Name -replace '.', '-') -join ' | ')
        }
        '| {0} |' -f (($_.PsObject.Properties.Value -replace $pattern, '\|') -join ' | ')
    }
}