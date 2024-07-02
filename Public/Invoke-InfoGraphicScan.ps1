function Invoke-InfoGraphicScan {
    <#
    .SYNOPSIS
        Invoke InfoGraphic scan
    .DESCRIPTION
        Scan HTML InfoGraphic file by removing variable data, generating hash
        for static code, and validating JSON data.
    .PARAMETER Path
        Path to HTML file
    .PARAMETER DataLine
        Report data JSON line number
    .PARAMETER TitleLine
        Report title line number
    .PARAMETER ReplaceText
        Text to replace
    .PARAMETER EndText
        End of JSON to remove
    .PARAMETER TempPath
        Temporary directory
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Invoke-InfoGraphicScan -Path C:\temp\100.html -DataLine 40 -TitleLine 7 -ReplaceText 'reportDataJson: ' -EndText ';'
        Invoke scan of InfoGraphic and return custom object with hash of static HTML file code and validation status of report data JSON.
    .EXAMPLE
        PS C:\> Get-ChildItem -Path C:\temp -File | Invoke-InfoGraphicScan -DataLine 40 -TitleLine 7 -ReplaceText 'reportDataJson: ' -EndText ';'
        Compare and thumbprint all HTML files in directory and output results.
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline, HelpMessage = 'Path to HTML file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Include "*.html" })]
        [System.String[]] $Path,

        [Parameter(Mandatory = $true, HelpMessage = 'Report data JSON line number')]
        [ValidateRange(1, 999)]
        [System.Int32] $DataLine,

        [Parameter(Mandatory = $true, HelpMessage = 'Report data JSON line number')]
        [ValidateRange(1, 999)]
        [System.Int32] $TitleLine,

        [Parameter(Mandatory = $true, HelpMessage = 'Text to repalce')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ReplaceText,

        [Parameter(Mandatory = $true, HelpMessage = 'End of JSON to remove')]
        [ValidateSet(';', ',')]
        [System.String] $EndText,

        [Parameter(Mandatory = $false, HelpMessage = 'Temporary directory')]
        [ValidateScript({ Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [System.String] $TempPath = "$env:TEMP\infograph_scan"
    )
    Begin {
        # CREATE TEMP DIRECTORY IF NOT EXIST
        if (-not (Test-Path -Path $TempPath -PathType Container)) { New-Item -Path $TempPath -ItemType Directory | Out-Null }
    }
    Process {
        foreach ($file in $Path) {

            # GET RAW DATA
            $list = [System.Collections.Generic.List[System.Object]]::new((Get-Content -Path $file))

            # EXTRACT TITLE
            $title = $list[($TitleLine - 1)]

            # EXTRACT DATA COMPONENT AND FROM ORIGINAL
            $data = $list[($DataLine - 1)]
            $data = $data.Replace($ReplaceText, '') # 'const reportDataJson = ', 'reportDataJson: '
            $data = $data.TrimEnd($EndText) # ';', ','

            # REMOVE TITLE LINE
            $list.RemoveAt(($TitleLine - 1))

            # REMOVE DATA - SUBTRACT 2 SINCE THE TITLE WAS JUST REMOVED IN THE CODE ABOVE
            $list.RemoveAt(($DataLine - 2))

            # GET FILE HASH VALUE
            $tempFile = Join-Path -Path $TempPath -ChildPath ([System.IO.Path]::GetRandomFileName())
            $list | Set-Content -Path $tempFile

            [PSCustomObject] @{
                Id        = (Split-Path -Path $file -Leaf)
                Title     = $title
                ValidJson = Test-Json -Json $data -ErrorAction SilentlyContinue
                Hash      = (Get-FileHash -Path $tempFile).Hash
            }

            # REMOVE TEMP FILE
            Remove-Item -Path $tempFile -Confirm:$false
        }
    }
}
