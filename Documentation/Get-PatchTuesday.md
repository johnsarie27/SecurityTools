# Get-PatchTuesday

## SYNOPSIS
Get the Patch Tuesday of a month

## SYNTAX

```
Get-PatchTuesday [[-Month] <Int32>] [[-Year] <Int32>] [[-DayOfWeek] <String>] [[-WeekOfMonth] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Get the Patch Tuesday, or any other day, of a month

## EXAMPLES

### EXAMPLE 1
```
Get-PatchTue -Month 6 -Year 2015
```

### EXAMPLE 2
```
Get-PatchTue June 2015
```

## PARAMETERS

### -Month
The month to check

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-Date).Month
Accept pipeline input: False
Accept wildcard characters: False
```

### -Year
The year to check

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Get-Date).Year
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayOfWeek
Day of week

```yaml
Type: String
Parameter Sets: (All)
Aliases: WeekDay

Required: False
Position: 3
Default value: Tuesday
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekOfMonth
Week of month

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.DateTime.
## NOTES
https://gallery.technet.microsoft.com/scriptcenter/Find-Patch-Tuesday-using-94484479

## RELATED LINKS
