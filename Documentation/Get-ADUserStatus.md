# Get-ADUserStatus

## SYNOPSIS
Get user status

## SYNTAX

```
Get-ADUserStatus [-Identity] <String> [<CommonParameters>]
```

## DESCRIPTION
Get user status information including password and logon details

## EXAMPLES

### EXAMPLE 1
```
Get-ADUserStatus -Identity jsmith
Gets the status information for user jsmith
```

## PARAMETERS

### -Identity
AD User Identity

```yaml
Type: String
Parameter Sets: (All)
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
General notes

## RELATED LINKS
