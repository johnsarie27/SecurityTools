---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Find-SavedCommand

## SYNOPSIS
Get command history matching word or phrase

## SYNTAX

```
Find-SavedCommand [-Phrase] <String> [<CommonParameters>]
```

## DESCRIPTION
This function will return results of commands run and stored in the HistorySavePath property of Get-PSReadLineOption Cmdlet. This typically traverses sessions and windows other than that currently running.

## EXAMPLES

### Example 1
```powershell
PS C:\> Find-SavedCommand -Phrase "ELBLoadBalancer -Name" -Results 100
```

Show the last 100 commands run using the phrase "ELBLoadBalancer -Name"

## PARAMETERS

### -Phrase
Search phrase

```yaml
Type: String
Parameter Sets: (All)
Aliases: Search, Terms

Required: True
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
