# Test-Performance

## SYNOPSIS
Test performance of script block

## SYNTAX

```
Test-Performance [-ScriptBlock] <ScriptBlock> [[-Iterations] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Test performance of script block over given number of executions

## EXAMPLES

### EXAMPLE 1
```
Test-Performance -ScriptBlock { Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 }
```

Run ScriptBlock 10 times and returns statistical results as shown below:

MaxMilliseconds : 3897
MinMilliseconds : 3756
AvgMilliseconds : 3824

## PARAMETERS

### -ScriptBlock
ScriptBlock to test performance

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Iterations
Number of test iterations

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Runs

Required: False
Position: 2
Default value: 10
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
