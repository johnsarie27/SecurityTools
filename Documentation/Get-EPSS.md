# Get-EPSS

## SYNOPSIS
Get EPSS information

## SYNTAX

```
Get-EPSS [[-CVE] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get EPSS information or score for specific CVE

## EXAMPLES

### EXAMPLE 1
```
Get-EPSS -CVE 'CVE-2022-27225'
Get the EPSS score for CVE 'CVE-2022-27225'
```

## PARAMETERS

### -CVE
Common Vulnerability Enumeration (CVE) ID

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.Object.
## NOTES
Name:     Get-EPSS
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2023-12-15
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
