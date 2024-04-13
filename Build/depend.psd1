@{
    # Defaults for all dependencies
    PSDependOptions  = @{
        Target     = 'CurrentUser'
        Parameters = @{
            # Use a local repository for offline support
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }

    }

    # Dependency Management modules
    # PackageManagement = '1.2.2'
    # PowerShellGet     = '2.0.1'

    # Common modules
    BuildHelpers     = '2.0.16'
    Pester           = '5.5.0'
    PlatyPS          = '0.14.2'
    psake            = '4.9.0'
    #PSDeploy         = '1.0.5'
    PSScriptAnalyzer = '1.22.0'
    ImportExcel      = '7.8.6'
}
