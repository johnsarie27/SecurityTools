function Test-DestinationPath {
    <#
    .SYNOPSIS
        Test for a proper destination path
    .DESCRIPTION
        Test for a proper destination path
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
        Returns path if path can be used as destination path
    .NOTES
        General notes
    #>
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
        [ValidatePattern('\.\w+')]
        [string] $Extension,

        [Parameter(Mandatory=$false,
        ValueFromPipeline=$false,
        ValueFromPipelineByPropertyName=$false)]
        [Alias('AO')]
        [switch] $AllowOverwrite
    )
    Begin {
        # ENSURE THE DESTINATION PATH IS IN A NON-PS-SPECIFIC FORMAT
        $Path = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($Path)
        Write-Verbose ('path: {0}' -f $Path)

        # VALIDATE PARENT PATH
        $parentDirectory = [System.IO.Path]::GetDirectoryName($Path)
        Write-Verbose ('parent directory: {0}' -f $parentDirectory)

        if ($null -eq $parentDirectory) { Throw 'Invalid file path' }
        if ($parentDirectory -eq [string]::Empty) { $parentDirectory = '.' }

        if (-not (Test-Path -Path $parentDirectory -PathType Container)) {
            Throw ('All or part of the directory "{0}" does not exist' -f $parentDirectory)
        }

        # JOIN FILE NAME AND PARENT PATH
        $fileName = [System.IO.Path]::GetFileName($Path)
        Write-Verbose ('file name: {0}' -f $fileName)

        $Path = Join-Path -Path $parentDirectory -ChildPath $fileName
        Write-Verbose ('path: {0}' -f $Path)

        # VALIDATE OR ADD EXTENSION
        $fileExtension = [system.IO.Path]::GetExtension($Path)
        Write-Verbose ('file extension: {0}' -f $fileExtension)
        if ($fileExtension -eq [string]::Empty) {
            # CHECK FOR EXISTING FOLDER WITH SAME NAME
            if (Test-Path -Path $Path -PathType Container) {
                Write-Warning 'New file will be created with same name as existing folder'
            }
            $Path = $Path + $Extension
            Write-Verbose ('Added extension [{0}] to path' -f $Extension)
        }
        elseif ($fileExtension -ne $Extension) {
            Throw 'Unsupported extension provided'
        }

        # CHECK IF FILE EXISTS OR IS READ ONLY
        $fileExist = Test-Path -LiteralPath $Path -PathType Leaf
        if ($fileExist -and -not $PSBoundParameters.ContainsKey('AllowOverwrite')) {
            Throw 'File exists. Use -AllowOverwrite to overwrite file.'
        }
        if ($fileExist -and $PSBoundParameters.ContainsKey('AllowOverwrite')) {
            $item = Get-Item -Path $Path
            if ($item.Attributes.ToString().Contains("ReadOnly")) {
                Throw 'File is read only'
            }
            Write-Warning 'File exists and will be overwritten.'
        }
    }
    End {
        # RETURN BOOLEAN RESULT
        $Path
    }
}
