# Out-MeasureResult

## SYNOPSIS
Outputs an object that shows maximum, minimum and average of an collection of
System.TimeSpan objects.

## SYNTAX

```
Out-MeasureResult [[-Measurement] <TimeSpan[]>] [<CommonParameters>]
```

## DESCRIPTION
Outputs an object that shows maximum, minimum and average of an collection of
System.TimeSpan objects.

## EXAMPLES

### EXAMPLE 1
```
$measured = [System.Collections.Generic.List[System.TimeSpan]]::new()
foreach ($run in (0..9)) {
```

\[System.GC\]::Collect()

    $measure = Measure-Command -Expression {
        $stringBuilder = \[System.Text.StringBuilder\]::new()
        foreach ($int in (0..10000)) {
            $stringBuilder.Append(" ")
        }
    }
$measured.Add($measure)
}

$measured | Out-MeasureResult | Format-List

MaxMilliseconds : 2570,0842
MinMilliseconds : 1852,0017
AvgMilliseconds : 2241,86343

## PARAMETERS

### -Measurement
Array of System.TimeSpan objects to measure

```yaml
Type: TimeSpan[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Accepts an System.TimeSpan object or a collection of System.TimeSpan objects
## OUTPUTS

## NOTES
This function comes from the chapter Increasing PowerShell Performance
in the "PowerShell Conference Book"

## RELATED LINKS
