---
external help file: UtilityFunctions-help.xml
Module Name: UtilityFunctions
online version:
schema: 2.0.0
---

# Get-DirItemAges

## SYNOPSIS
Generate age information for a directory of files and sub-files

## SYNTAX

```
Get-DirItemAges [-Path] <String> [[-AgeInDays] <Int32>] [-NoRecurse] [<CommonParameters>]
```

## DESCRIPTION
This function generates a report of content details for a given folder.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-DirItemAges -Directory 'D:\Database\logs' -AgeInDays 7
```

Get all content details for D:\Database\logs using 7 day measurement

## PARAMETERS

### -AgeInDays
Sample age to measure files create before/after

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoRecurse
Do not recurse through children directories

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

### -Path
Target directory

```yaml
Type: String
Parameter Sets: (All)
Aliases: Directory, Folder

Required: True
Position: 0
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

### System.Object

## NOTES

## RELATED LINKS
