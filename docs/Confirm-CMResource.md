---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Confirm-CMResource

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### update
```
Confirm-CMResource [-PSDrive <String>] -UpdateGroupName <String> [<CommonParameters>]
```

### collection
```
Confirm-CMResource [-PSDrive <String>] -CollectionName <String> [<CommonParameters>]
```

### device
```
Confirm-CMResource [-PSDrive <String>] -DeviceName <String> [<CommonParameters>]
```

### drive
```
Confirm-CMResource -PSDrive <String> [<CommonParameters>]
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
Type: String
Parameter Sets: collection
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceName
Device name

```yaml
Type: String
Parameter Sets: device
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PSDrive
PS Drive name

```yaml
Type: String
Parameter Sets: update, collection, device
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: drive
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateGroupName
Update group name

```yaml
Type: String
Parameter Sets: update
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
