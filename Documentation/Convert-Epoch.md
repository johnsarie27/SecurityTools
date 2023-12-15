# Convert-Epoch

## SYNOPSIS
Convert epoch

## SYNTAX

### __dt (Default)
```
Convert-Epoch [[-Date] <DateTime>] [<CommonParameters>]
```

### __sc
```
Convert-Epoch [-Seconds] <Int64> [<CommonParameters>]
```

### __ms
```
Convert-Epoch [-Milliseconds] <Int64> [<CommonParameters>]
```

## DESCRIPTION
Convert epoch to date/time or date/time to epoch

## EXAMPLES

### EXAMPLE 1
```
Convert-Epoch -Seconds 1618614176
Converts epoch time to date/time object
```

## PARAMETERS

### -Date
DateTime object

```yaml
Type: DateTime
Parameter Sets: __dt
Aliases:

Required: False
Position: 1
Default value: (Get-Date)
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Seconds
Epoch Time in seconds

```yaml
Type: Int64
Parameter Sets: __sc
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Milliseconds
Epoch Time in milliseconds

```yaml
Type: Int64
Parameter Sets: __ms
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.DateTime.
## OUTPUTS

### System.Object.
## NOTES
General notes

## RELATED LINKS
