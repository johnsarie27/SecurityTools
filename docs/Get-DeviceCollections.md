---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-DeviceCollections

## SYNOPSIS
Get all Collections for a given Device

## SYNTAX

### config (Default)
```
Get-DeviceCollections -DeviceName <String> -ConfigurationData <String> [<CommonParameters>]
```

### drive
```
Get-DeviceCollections -DeviceName <String> -PSDrive <String> [<CommonParameters>]
```

## DESCRIPTION
This function accepts a device name and outputs all collections that contain the provided device.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-DeviceCollections -DeviceName Server01
```

Retrieve all Collections for Device with name Server01

## PARAMETERS

### -ConfigurationData
Configuration data file

```yaml
Type: String
Parameter Sets: config
Aliases: ConfigFile, DataFile, CofnigData, File, Path

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
Parameter Sets: (All)
Aliases: Name, ComputerName

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PSDrive
PSDriver for Configuration Manager

```yaml
Type: String
Parameter Sets: drive
Aliases: Drive, DriveName, CMDrive

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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
