# Convert-TimeZone

## SYNOPSIS
Convert US time zones

## SYNTAX

```
Convert-TimeZone [[-Time] <String[]>] [[-SourceTimeZone] <String>] [-TargetTimeZone] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Convert US and UTC time zones

## EXAMPLES

### EXAMPLE 1
```
Convert-TimeZone -Time "2019-06-01 10:00 PM" -Source UTC -Target Eastern
Convert "2019-06-01 10:00 PM" from UTC to Eastern time zone.
```

## PARAMETERS

### -Time
Time to convert

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-Date)
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SourceTimeZone
Time zone of Time parameter (defaults to local)

```yaml
Type: String
Parameter Sets: (All)
Aliases: Source

Required: False
Position: 2
Default value: Local
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetTimeZone
Time zone of desired conversion (default is UTC)

```yaml
Type: String
Parameter Sets: (All)
Aliases: Target

Required: True
Position: 3
Default value: UTC
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[].
## OUTPUTS

### System.Object.
## NOTES
\[DateTime\]::UtcNow
$DateTimeObject.ToLocalTime()
$DateTimeObject.ToUniversalTime()

## RELATED LINKS
