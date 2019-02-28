---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-HAGroup

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Get-HAGroup [-PSDrive] <String> [-CollectionNames] <String[]> [[-Station] <String>] [[-ServerType] <String>]
 [<CommonParameters>]
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

### -CollectionNames
Array of CM Collection Names

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Collections, GroupNames

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PSDrive
PSDriver for Configuration Manager

```yaml
Type: String
Parameter Sets: (All)
Aliases: Drive, DriveName, CMDrive

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ServerType
Server type

```yaml
Type: String
Parameter Sets: (All)
Aliases: Type, Purpose, Designation
Accepted values: apps, data

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Station
Primary or secondary HA group

```yaml
Type: String
Parameter Sets: (All)
Aliases: HAGroup, Group
Accepted values: primary, secondary

Required: False
Position: 2
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
