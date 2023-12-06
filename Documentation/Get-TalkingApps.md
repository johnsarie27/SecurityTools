---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-TalkingApps

## SYNOPSIS
Get Windows processes with open network connections

## SYNTAX

```
Get-TalkingApps [[-ComputerName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Query Windows processes and display open connections

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-TalkingApps.ps1 -ComputerName MyServer
```

Get all processes with open network connections on MyServer

## PARAMETERS

### -ComputerName
Target computer name

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name, Computer, Host, HostName, CN

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
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
