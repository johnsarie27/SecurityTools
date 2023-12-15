# Get-SavedHistory

## SYNOPSIS
Find command matching search term(s)

## SYNTAX

```
Get-SavedHistory [-Search] <String> [<CommonParameters>]
```

## DESCRIPTION
Search for commands in the stored session history for PowerShell that
match the provided keyword(s).
If no keywards are provided all unique
commands will be returned.

## EXAMPLES

### EXAMPLE 1
```
Get-SavedHistory -Search "ELBLoadBalancer -Name"
```

## PARAMETERS

### -Search
Search term or phrase (best results with a contiguous phrase)

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

### System.String.
## OUTPUTS

### System.Object[].
## NOTES
See article: https://serverfault.com/questions/891265/how-to-search-powershell-command-history-from-previous-sessions

## RELATED LINKS
