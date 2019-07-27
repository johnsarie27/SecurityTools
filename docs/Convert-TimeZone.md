---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

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

### Example 1
```powershell
PS C:\> Convert-TimeZone -Time "2019-06-01 10:00 PM" -Source UTC -Target Eastern
```

Convert "2019-06-01 10:00 PM" from UTC to Eastern time zone.

## PARAMETERS

### -SourceTimeZone
Source time zone

```yaml
Type: String
Parameter Sets: (All)
Aliases: Source
Accepted values: Local, UTC, Pacific, Mountain, Central, Eastern, GMT

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetTimeZone
Target time zone

```yaml
Type: String
Parameter Sets: (All)
Aliases: Target
Accepted values: Local, UTC, Pacific, Mountain, Central, Eastern, GMT

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Time
Time to convert

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
