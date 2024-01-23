# Get-DirectoryReport

## SYNOPSIS
Get directory statistics

## SYNTAX

```
Get-DirectoryReport [-Path] <String> [[-SizeInGb] <Double>] [[-OutputDirectory] <String>] [-NoTotals] [-All]
 [<CommonParameters>]
```

## DESCRIPTION
Get summary of all files and folders in specified directory that are
greater than or equal to specified size (defaul size is 1GB).

## EXAMPLES

### EXAMPLE 1
```
Get-DirectoryReport -Path C:\MyData -SizeInGb 4
```

## PARAMETERS

### -Path
Target folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SizeInGb
Threshold for which to measure file and folder sizes

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputDirectory
Output report directory (directory must already exist)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoTotals
Skip calculatation of file size totals and number of files totals

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

### -All
Measure all files of any size

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

### None.
## OUTPUTS

### System.Object.
## NOTES

## RELATED LINKS
