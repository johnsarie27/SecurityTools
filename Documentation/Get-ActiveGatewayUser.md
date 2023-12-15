# Get-ActiveGatewayUser

## SYNOPSIS
Get users actively connected to the remote desktop gateway

## SYNTAX

```
Get-ActiveGatewayUser [-ComputerName] <String> [<CommonParameters>]
```

## DESCRIPTION
This function shows users who have active connections through the
remote desktop gateway provided.

## EXAMPLES

### EXAMPLE 1
```
Get-ActiveGWUser -CompuaterName Gateway
Get all users connected through the RDGW "Gateway"
```

## PARAMETERS

### -ComputerName
Remote desktop computer name

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name, CN, Computer, System, Target

Required: True
Position: 1
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

## RELATED LINKS
