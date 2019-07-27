---
external help file: UtilityFunctions-help.xml
Module Name: UtilityFunctions
online version:
schema: 2.0.0
---

# Find-ServerPendingReboot

## SYNOPSIS
Check if a server is pending reboot

## SYNTAX

```
Find-ServerPendingReboot [[-ComputerName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Check if a server is pending reboot

## EXAMPLES

### Example 1
```powershell
PS C:\> FindServerIsPendingReboot -ComputerName "WIN-VU0S8","WIN-FJ6FH","WIN-FJDSH","WIN-FG3FH"
```

ComputerName                                          RebootIsPending
------------                                          ---------------
WIN-VU0S8                                             False
WIN-FJ6FH                                             True
WIN-FJDSH                                             True
WIN-FG3FH                                             True

## PARAMETERS

### -ComputerName
Computer name

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN

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

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
