# Get-WhoIs

## SYNOPSIS
Get WhoIs information

## SYNTAX

```
Get-WhoIs [-IPAddress] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get WhoIs information

## EXAMPLES

### EXAMPLE 1
```
Get-WhoIs -IPAddress '8.8.8.8'
Get's WhoIs info for the ip 8.8.8.8
```

## PARAMETERS

### -IPAddress
Target IP address

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
I took this from the link below.
I've made some minor modifications.
https://www.powershellgallery.com/packages/PSScriptTools/2.9.0/Content/functions%5CGet-WhoIs.ps1

## RELATED LINKS
