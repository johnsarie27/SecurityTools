---
external help file: UtilityFunctions-help.xml
Module Name: UtilityFunctions
online version:
schema: 2.0.0
---

# Get-DirStats

## SYNOPSIS
Show directory statistics for a given directory

## SYNTAX

```
Get-DirStats [[-Path] <String>] [[-SizeInGb] <Int32>] [-All] [-Totals] [<CommonParameters>]
```

## DESCRIPTION
This function will display all files and folders in a given directory that are greater than or equal to a given size in GB. The defaul is 1GB.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-DirStats -Path C:\MyData -SizeInGb 4
```

Show objects that are greater than 4GB in C:\MyData

## PARAMETERS

### -All
Measure all files of any size

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
Directory to evaluate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SizeInGb
Minimum file size to search for

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

### -Totals
Show totals at end

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
