function Get-KEVList {
    <# =========================================================================
    .SYNOPSIS
        Get Known Exploited Vulnerability list
    .DESCRIPTION
        Get Known Exploited Vulnerabilities as array of objects or download as
        CSV file
    .PARAMETER DownloadCSV
        Download CSV file
    .PARAMETER OutputDirectory
        Output Directory
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Get-KEVList
        Returns an object containing known exploited vulnerability catalog
    .NOTES
        Name:     Get-KEVList
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-08-13
        - 0.1.0 - Initial version
        - 0.1.1 - Added dynamic parameter
        Comments: This function was written in order to learn how to use dynamic
        parameters. The dynamic parameter can be replaced with a single
        parameter named OutputDirectory.
        General notes
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Download CSV file')]
        [System.Management.Automation.SwitchParameter] $DownloadCSV
    )
    DynamicParam {
        if ($PSBoundParameters.ContainsKey('DownloadCSV')) {
            # SET DYNAMIC PARAMETERS
            $dynamicParams = @{
                OutputDirectory = @{
                    Type       = 'System.String'
                    Attributes = @{
                        Mandatory   = $true
                        HelpMessage = 'Output directory'
                    }
                }
            }

            # CREATE PARAMETER DICTIONARY
            $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

            # CREATE OBJECTS
            foreach ($param in $dynamicParams.GetEnumerator()) {
                # CREATE ATTRIBUTE OBJECT
                $paramAttribute = [System.Management.Automation.ParameterAttribute]::new()

                # POPULATE COLLECTION WITH ATTRIBUTES
                foreach ($attribute in $param.Value['Attributes'].GetEnumerator()) {
                    $paramAttribute.($attribute.Key) = $attribute.Value
                }

                # CREATE COLLECTION
                $attrCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
                $attrCollection.Add($paramAttribute)

                # CREATE RUNTIMEDEFINEDPARAMETER OBJECT
                $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                    $param.Key, $param.Value['Type'], $attrCollection
                )

                # ADD PARAMETER TO DICTIONARY
                $paramDictionary.Add($param.Key, $parameter)
            }

            # RETURN PARAMETER DICTIONARY
            return $paramDictionary
        }
    }
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
        # $schema = 'https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities_schema.json'

        # VALIDATE OUTPUTDIRECTORY PARAMETER
        if ($PSBoundParameters.ContainsKey('OutputDirectory')) {
            if (-Not (Test-Path -Path $PSBoundParameters.OutputDirectory -PathType Container)) {
                Write-Error -Message ('Invalid output directory "{0}"' -f $PSBoundParameters.OutputDirectory) -ErrorAction Stop
            }
        }
    }
    Process {
        if ($PSBoundParameters.ContainsKey('DownloadCSV')) {
            # SET URI
            $uri = 'https://www.cisa.gov/sites/default/files/csv/known_exploited_vulnerabilities.csv'

            # SET OUTPUT PATH
            $outFile = Join-Path -Path $PSBoundParameters['OutputDirectory'] -ChildPath (Split-Path -Path $uri -Leaf)

            # DOWNLOAD CSV FILE
            Invoke-WebRequest -Uri $uri -OutFile $outFile
        }
        else {
            # SET URI
            $uri = 'https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json'

            # GET KNOWN EXPLOITED VULNERABILITIES
            Invoke-RestMethod -Uri $uri
        }
    }
}