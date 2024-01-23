# Get-ItemAge

## SYNOPSIS
Generate age information for a directory of files and sub-files

## SYNTAX

```
Get-ItemAge [-Path] <String> [[-AgeInDays] <Int32>] [-NoRecurse] [<CommonParameters>]
```

## DESCRIPTION
This function generates a report of content details for a given folder.

## EXAMPLES

### EXAMPLE 1
```
Get-ItemAge -Directory 'D:\Database\logs' -AgeInDays 7
Get all content details for D:\Database\logs using 7 day measurement
```

## PARAMETERS

### -Path
Full path to the target directory for which the report should be
generated.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Directory, Folder

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AgeInDays
Sample age to measure number of files created since.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 7
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoRecurse
This switch parameter causes the scan of only the first level of
folders.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
### System.Int.
## OUTPUTS

### System.Object.
## NOTES
https://blogs.technet.microsoft.com/pstips/2017/05/20/display-friendly-file-sizes-in-powershell/
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-6

## RELATED LINKS
