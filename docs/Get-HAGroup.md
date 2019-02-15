---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-HAGroup

## SYNOPSIS
Get all nodes in a given subset of systems

## SYNTAX

```
Get-HAGroup [-ConfigurationData] <String> [-Environment] <String> [[-Station] <String>]
 [[-ServerType] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function will return all systems in the specified environment and station

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-HAGroup -Env STG -Group primary -Path C:\data.json
```

Get all systems in the staging environment that are part of the primary HA group

## PARAMETERS

### -ConfigurationData
Configuration data file

```yaml
Type: String
Parameter Sets: (All)
Aliases: ConfigFile, DataFile, CofnigData, File, Path

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Environment
Collection environment

```yaml
Type: String
Parameter Sets: (All)
Aliases: Env
Accepted values: STG, PRD, REF

Required: True
Position: 1
Default value: None
Accept pipeline input: False
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
