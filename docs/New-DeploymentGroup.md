---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# New-DeploymentGroup

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### start
```
New-DeploymentGroup -StartTime <String> [-TimeZone <String>] -CollectionName <String[]> [<CommonParameters>]
```

### end
```
New-DeploymentGroup -EndTime <String> [-TimeZone <String>] -CollectionName <String[]> [<CommonParameters>]
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

### -CollectionName
Collection name

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -EndTime
End time for last collection

```yaml
Type: String
Parameter Sets: end
Aliases: ET

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
Start time for first collection

```yaml
Type: String
Parameter Sets: start
Aliases: ST

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZone
Time zone for start time

```yaml
Type: String
Parameter Sets: (All)
Aliases: TZ
Accepted values: Eastern, Pacific, UTC

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

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
