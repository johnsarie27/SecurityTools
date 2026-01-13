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
    Pester           = '5.7.1'
    psake            = '4.9.1'
    #PSDeploy         = '1.0.5'
    PSScriptAnalyzer = '1.24.0'
    ImportExcel      = '7.8.10'
}
