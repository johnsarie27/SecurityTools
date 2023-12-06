---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-Software

## SYNOPSIS
Get all installed software

## SYNTAX

```
Get-Software [-ExcludeUsers] [-All] [<CommonParameters>]
```

## DESCRIPTION
Get software inventory from Windows Registry

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-Software -All
```

This returns all properties of the registry keys holding the software inventory

## PARAMETERS

### -All
Return all properties

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeUsers
Exclude user software registry hive

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: IU, Users

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

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
