# Get-KEVList

## SYNOPSIS
Get Known Exploited Vulnerability list

## SYNTAX

```
Get-KEVList [[-Format] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get Known Exploited Vulnerabilities as array of objects or download as
CSV or JSON file

## EXAMPLES

### EXAMPLE 1
```
Get-KEVList
Returns an object containing known exploited vulnerability catalog
```

## PARAMETERS

### -Format
Format to download catalog

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### None.
## NOTES
Name:     Get-KEVList
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-08-13
- 0.1.0 - Initial version
- 0.1.1 - Added dynamic parameter
- 0.1.2 - Added output format options CSV, JSON, and Schema
Comments: This function was written in order to learn how to use dynamic
parameters.
The dynamic parameter can be replaced with a single
parameter named OutputDirectory.
General notes
https://cyber.dhs.gov/bod/22-01/
https://www.cisa.gov/known-exploited-vulnerabilities
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters

## RELATED LINKS
