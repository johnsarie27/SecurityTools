---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# New-PatchDeployment

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### one (Default)
```
New-PatchDeployment [-PSDrive <String>] -UpdateGroupName <String> -CollectionName <String> -Deadline <DateTime>
 [<CommonParameters>]
```

### many
```
New-PatchDeployment [-PSDrive <String>] -UpdateGroupName <String> -PatchTimes <PSObject[]> [<CommonParameters>]
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
CM Collection Name

```yaml
Type: String
Parameter Sets: one
Aliases: Collection, DeviceCollection

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Deadline
Deadline for patch install

```yaml
Type: DateTime
Parameter Sets: one
Aliases: DeadlineDate, Date

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PSDrive
PSDrive for Configuration Manager

```yaml
Type: String
Parameter Sets: (All)
Aliases: Drive, DriveName, CMDrive

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PatchTimes
PSCustomObject with values Name and UTC

```yaml
Type: PSObject[]
Parameter Sets: many
Aliases: Collections, Groups

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateGroupName
CM Software Update Group name

```yaml
Type: String
Parameter Sets: (All)
Aliases: SoftwareUpdateGroup, UGN, SUGN

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
