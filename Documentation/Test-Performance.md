# Test-Performance

## SYNOPSIS
Test performance of script block

## SYNTAX

```
Test-Performance [-ScriptBlock] <ScriptBlock> [[-Runs] <Int32>] [-ShowResults] [<CommonParameters>]
```

## DESCRIPTION
Test performance of script block over given number of executions

## EXAMPLES

### EXAMPLE 1
```
Test-Performance -SB $S
```

Run ScriptBlock $S 10 times and returns statistical results as shown below:

MaxMilliseconds : 3897
MinMilliseconds : 3756
AvgMilliseconds : 3824

## PARAMETERS

### -ScriptBlock
ScriptBlock to test performance

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases: SB

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Runs
Number of test runs

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowResults
Show all run results in milliseconds

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: All, ShowAll

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

### System.Object[].
## NOTES
General notes

## RELATED LINKS
