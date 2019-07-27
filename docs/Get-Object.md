---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-Object

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### object (Default)
```
Get-Object -ObjectList <Object[]> -DisplayProperty <String> [-Index] [<CommonParameters>]
```

### string
```
Get-Object -ObjectList <Object[]> [-String] [-Index] [<CommonParameters>]
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

### -DisplayProperty
Object property to display

```yaml
Type: String
Parameter Sets: object
Aliases: Name, DP

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Index
Return object index instead of object

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

### -ObjectList
List of objects to choose from

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: List, OL

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -String
Object type of string

```yaml
Type: SwitchParameter
Parameter Sets: string
Aliases:

Required: True
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
