---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-WinLogs

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### list (Default)
```
Get-WinLogs [-List] [<CommonParameters>]
```

### events
```
Get-WinLogs -Id <Int32> [-ComputerName <String>] [-Results <Int32>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ComputerName
Hostname of target computer

```yaml
Type: String
Parameter Sets: events
Aliases: Name, Computer, CN

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
Event Table Id

```yaml
Type: Int32
Parameter Sets: events
Aliases: Event, EventId, EventTableId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -List
List available events

```yaml
Type: SwitchParameter
Parameter Sets: list
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Results
Number of results to return

```yaml
Type: Int32
Parameter Sets: events
Aliases:

Required: False
Position: Named
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
