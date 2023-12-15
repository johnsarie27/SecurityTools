# Get-CVSSv3BaseScore

## SYNOPSIS
Get CVSS v3 score for the given CVE ID

## SYNTAX

```
Get-CVSSv3BaseScore [-CVE] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get the first occurrence of 'CVSS 3.0 Base Score \[X\]' from the NVD site
page for the given CVE ID

## EXAMPLES

### EXAMPLE 1
```
Get-CVSSv3BaseScore -CVE "CVE-2020-2659"
Scrapes the NVD NIST page and returns CVSS v3 score for CVE "CVE-2020-2659"
```

## PARAMETERS

### -CVE
CVE ID

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[].
## OUTPUTS

### System.Object.
## NOTES
General notes

## RELATED LINKS
