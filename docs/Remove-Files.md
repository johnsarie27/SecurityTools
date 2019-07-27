---
external help file: UtilityFunctions-help.xml
Module Name: UtilityFunctions
online version:
schema: 2.0.0
---

# Remove-Files

## SYNOPSIS
Remove files in a directory based on age

## SYNTAX

```
Remove-Files [-Directory] <String> [-Age] <Int32> [[-Extension] <String>] [-Recurse] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function will remove all log files prior to the provided number of days in the provided directory. It can also remove log files from sub-directories when the -Recurse switch is provided.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-Files -Folder 'E:\Logs' -Age 30 -Extension csv
```

Remove all CSV files older than 30 days in E:\logs

### Example 2
```powershell
PS C:\> Remove-Files -Folder 'C\temp\logs' -Age 7 -Recurse
```

Remove all log files in C:\temp\logs older than 7 days recursing through sub-directories

## PARAMETERS

### -Age
Age (in days) for removal

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Directory
Targer folder for file removal

```yaml
Type: String
Parameter Sets: (All)
Aliases: Folder, Path, Dir

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Extension
File type to remove

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: log, csv, txt, *

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
Recurse through subfolders and delete

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

### System.String

### System.Int

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS
