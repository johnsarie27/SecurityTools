# ConvertFrom-IISLog

## SYNOPSIS
Convert from IIS log

## SYNTAX

```
ConvertFrom-IISLog [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Convert from IIS log to objects

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-IISLog -Path C:\logs\myLog.log
Converts log data into objects
```

## PARAMETERS

### -Path
Path to IIS log file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.Management.Automation.PSCustomObject.
## NOTES
Name:     ConvertFrom-IISLog
Author:   Justin Johns
Version:  0.1.4 | Last Edit: 2022-11-13
- 0.1.4 - Code clean
- 0.1.3 - Added pipeline input and ordered properties
- 0.1.2 - Get headers from log file
- 0.1.1 - Updated code to skip header rows
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
