---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-LoggedOnUser

## SYNOPSIS
Display all logged on users

## SYNTAX

```
Get-LoggedOnUser [[-ComputerName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Display all logged on users

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-LoggedOnUser -ComputerName MyServer
```

Show all users logged onto MyServer

## PARAMETERS

### -ComputerName
Target hostname

```yaml
Type: String
Parameter Sets: (All)
Aliases: Hostname, Host, Computer, CN

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
