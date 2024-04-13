# Get-LoggedOnUser

## SYNOPSIS
Show all users currently logged onto system

## SYNTAX

```
Get-LoggedOnUser [[-ComputerName] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function gets all user sessions on a remote system.

## EXAMPLES

### EXAMPLE 1
```
Get-ConnectedUser -ComputerName $Computer
```

## PARAMETERS

### -ComputerName
Hostname or IP address of target system to find users.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CN

Required: False
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

### System.String.
## NOTES

## RELATED LINKS
