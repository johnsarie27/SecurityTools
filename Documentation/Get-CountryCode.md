# Get-CountryCode

## SYNOPSIS
Get Country Code

## SYNTAX

### __cde (Default)
```
Get-CountryCode [-Code] <String> [<CommonParameters>]
```

### __cty
```
Get-CountryCode [-Country] <String> [<CommonParameters>]
```

## DESCRIPTION
Get country from 2- or 3-letter country code

## EXAMPLES

### EXAMPLE 1
```
Get-CountryCode AS
Returns the country data for "American Somoa"
```

## PARAMETERS

### -Code
Country code (2- or 3-letter)

```yaml
Type: String
Parameter Sets: __cde
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Country
Country name

```yaml
Type: String
Parameter Sets: __cty
Aliases:

Required: True
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

### System.Object.
## NOTES
Name:     Get-CountryCode
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2022-08-23
- 0.1.0 - Initial version
- 0.1.1 - Added global variable to prevent repeated web requests
Comments: \<Comment(s)\>
General notes
https://www.iso.org/obp/ui/#search
https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
https://datahub.io/core/country-list

## RELATED LINKS
