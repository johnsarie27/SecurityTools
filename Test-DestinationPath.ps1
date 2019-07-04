function Test-DestinationPath {
    <# =========================================================================
    .SYNOPSIS
        Validate path
    .DESCRIPTION
        Validate path meets use cases. See Pester tests file for user cases.
    .PARAMETER Path
        Path to validate
    .PARAMETER Extension
        Desired extension
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Test-DestinationPath -Path C:\Users\JSmith\TestFolder\file.xml
        Returns a "True" value if path can be used
    .NOTES
        General notes
    ========================================================================= #>
    [OutputType([System.String])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
        Position=0,
        ValueFromPipeline=$false,
        ValueFromPipelineByPropertyName=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [Parameter(Mandatory=$true,
        Position=1,
        ValueFromPipeline=$false,
        ValueFromPipelineByPropertyName=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $Extension,

        [Parameter(Mandatory=$false, ValueFromPipeline=$false, ValueFromPipelineByPropertyName=$false)]
        [switch] $Force=$false
    )
    Begin {
        # ENSURE THE DESTINATION PATH IS IN A NON-PS-SPECIFIC FORMAT
        $Path = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($Path)
        Write-Verbose ('path: {0}' -f $Path)

        # VALIDATE PARENT PATH
        $parentDirectory = [System.IO.Path]::GetDirectoryName($Path)
        if ($null -eq $parentDirectory) {
            Throw 'Invalid file path'
        }
        if ($parentDirectory -eq [string]::Empty) {
            $parentDirectory = '.'
        }
        if (-not (Test-Path -Path $parentDirectory -PathType Container)) {
            Throw 'Invalid file path. Parent directory does not exist'
        }
        Write-Verbose ('parent directory: {0}' -f $parentDirectory)

        # JOIN FILE NAME AND PARENT PATH
        $fileName = [System.IO.Path]::GetFileName($Path)
        Write-Verbose ('file name: {0}' -f $fileName)
        $Path = Join-Path -Path $parentDirectory -ChildPath $fileName
        Write-Verbose ('path: {0}' -f $Path)

        # VALIDATE OR ADD EXTENSION
        $fileExtension = [system.IO.Path]::GetExtension($Path)
        Write-Verbose ('file extension: {0}' -f $fileExtension)
        if ($fileExtension -eq [string]::Empty) {
            $Path = $Path + $Extension
            Write-Verbose ('Added extension [{0}] to path' -f $Extension)
        }
        elseif ($fileExtension -ne $Extension) {
            Throw 'Unsupported extension provided'
        }

        # CHECK IF FILE EXISTS OR IS READ ONLY
        $fileExist = Test-Path -LiteralPath $Path -PathType Leaf
        if ($fileExist -and $Force -eq $false) {
            Throw 'File exists. Use -Force to overwrite file.'
        }
        if ($fileExist -and $Force -eq $true) {
            $item = Get-Item -Path $Path
            if ($item.Attributes.ToString().Contains("ReadOnly")) {
                Throw 'File is read only'
            }
        }
    }
    End {
        # RETURN BOOLEAN RESULT
        $Path
    }
}