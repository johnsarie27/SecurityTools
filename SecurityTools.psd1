﻿# ==============================================================================
# Module manifest for module 'SecurityTools'
# Generated by: Justin Johns
# Generated on: 4/12/2018
# ==============================================================================

@{
    # Script module or binary module file associated with this manifest.
    RootModule        = 'SecurityTools.psm1'

    # Version number of this module.
    ModuleVersion     = '0.9.3'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '46425f03-e6da-4deb-957c-c2dba2b2b777'

    # Author of this module
    Author            = 'Justin Johns'

    # Company or vendor of this module
    # CompanyName = 'Unknown'

    # Copyright statement for this module
    Copyright         = '(c) 2018 Justin Johns. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Functions used in reporting and management of security devices and resources.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        'ImportExcel'
        #'SqlServer'
        #'ActiveDirectory' # FOR Get-ADUserStatus
        #'GroupPolicy' # FOR Get-RSOP
        #'PSNetAddressing'
        #'PSPKI'
    )
    # CONSIDER ADDING PSPKI FOR SMARTCARDCERTS

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess    = @(
        './Private/ADUser.types.ps1xml'
        './Private/Process.types.ps1xml'
        './Private/Service.types.ps1xml'
    )

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Compare-List'
        'Convert-Epoch'
        'Convert-Hexadecimal'
        'Convert-SecureKey'
        'Convert-TimeZone'
        'ConvertFrom-GZipString'
        'ConvertFrom-IISLog'
        'ConvertTo-FlatObject'
        'ConvertTo-Hex'
        'ConvertTo-MarkdownTable'
        'Expand-GZip'
        'Expand-URL'
        'Export-NPMAudit'
        'Export-ScanReportAggregate'
        'Export-ScanReportSummary'
        'Export-SQLVAReport'
        'Export-SQLVAReportAggregate'
        'Export-VeracodeReport'
        'Export-WebScan'
        'Find-LANHost'
        'Find-ServerPendingReboot'
        'Find-WinEvent'
        'Get-ActiveGatewayUser'
        'Get-ADUserStatus'
        'Get-AlternateDataStream'
        'Get-CountryCode'
        'Get-CVSSv3BaseScore'
        'Get-Decoded'
        'Get-DirectoryReport'
        'Get-DomainRegistration'
        'Get-Encoded'
        'Get-EPSS'
        'Get-FileHeader'
        'Get-FileInfo'
        'Get-FolderSize'
        'Get-Ipinfo'
        'Get-ItemAge'
        'Get-KEVList'
        'Get-LoggedOnUser'
        'Get-MsiInfo'
        'Get-Object'
        'Get-PatchTuesday'
        'Get-RSOP'
        'Get-SavedHistory'
        'Get-Software'
        'Get-StringHash'
        'Get-TCPConnection'
        'Get-UncPath'
        'Get-Weather'
        'Get-WhoIs'
        'Get-WindowsEventCatalog'
        'Get-WinInfo'
        'Install-GitHubModule'
        'Install-ModuleFromPackage'
        'Invoke-InfoGraphicScan'
        'Invoke-NetScan'
        'New-RandomString'
        'Out-MeasureResult'
        'Read-EncryptedFile'
        'Save-KBFile'
        'Test-Performance'
        'Uninstall-MSI'
        'Update-GitHubModule'
        'Write-EncryptedFile'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @(
        'EventTable'
        'InfoModel'
    )

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    # ITEMS MUST BE LISTED HERE IN THE PSD1 FILE AS WELL AS THE PSM1 FILE TO SUCCESSFULLY EXPORT THEM
    AliasesToExport   = @(
        'Compare-Lists'
        'Get-ActiveGWUser'
        'Get-DirItemAges'
        'Get-DirStats'
        'Get-RandomString'
        'Get-WinLogs'
    )

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/johnsarie27/SecurityTools'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}
