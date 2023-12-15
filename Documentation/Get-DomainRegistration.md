# Get-DomainRegistration

## SYNOPSIS
Get domain registration info

## SYNTAX

```
Get-DomainRegistration [-Domain] <String> [-ApiKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Get domain registration info

## EXAMPLES

### EXAMPLE 1
```
Get-DomainRegistration -Domain google.com
Get domain registration info for google.com
```

## PARAMETERS

### -Domain
Target Domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ApiKey
API Key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.Object.
## NOTES
General notes
https://whois.whoisxmlapi.com/documentation/making-requests
API token required
https://rdap.verisign.com/com/v1/domain/\<DOMAIN\>
https://domainsrdap.googleapis.com/v1/domain/\<DOMAIN\>

## RELATED LINKS
