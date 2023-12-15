# Get-Ipinfo

## SYNOPSIS
Get IP address info

## SYNTAX

```
Get-Ipinfo [-IPAddress] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get IP address info

## EXAMPLES

### EXAMPLE 1
```
Get-Ipinfo -IPAddress '1.1.1.1'
Get IP address info for IP '1.1.1.1'
```

## PARAMETERS

### -IPAddress
IPV4 address

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

### System.Object[].
## NOTES
General notes
https://ipinfo.io/
To get more data (e.g., ASN or Company info) a token must be used

## RELATED LINKS
