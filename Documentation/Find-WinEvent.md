# Find-WinEvent

## SYNOPSIS
Get Windows Event Viewer logs

## SYNTAX

### __lst (Default)
```
Find-WinEvent [-List] [<CommonParameters>]
```

### __evt
```
Find-WinEvent -Id <Int32> [-ComputerName <String>] [-Results <Int32>] [-StartTime <DateTime>]
 [-EndTime <DateTime>] [-Data <String[]>] [<CommonParameters>]
```

## DESCRIPTION
This script will query the Windows Event Viewer and provide log details
based on the criteria provided.

## EXAMPLES

### EXAMPLE 1
```
Find-WinEvent.ps1 -Id 8 -ComputerName $Server -Results 10
Display last 10 RDP Sessions
```

## PARAMETERS

### -List
List available events

```yaml
Type: SwitchParameter
Parameter Sets: __lst
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Id of event in EventTable

```yaml
Type: Int32
Parameter Sets: __evt
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName
Hostname of remote system from which to pull logs.

```yaml
Type: String
Parameter Sets: __evt
Aliases: CN

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Results
Number of results to return.

```yaml
Type: Int32
Parameter Sets: __evt
Aliases:

Required: False
Position: Named
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
Start time for event serach

```yaml
Type: DateTime
Parameter Sets: __evt
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndTime
End time for event serach

```yaml
Type: DateTime
Parameter Sets: __evt
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
String to search for in event data

```yaml
Type: String[]
Parameter Sets: __evt
Aliases:

Required: False
Position: Named
Default value: None
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
Name:     Find-WinEvent
Author:   Justin Johns
Version:  0.1.4 | Last Edit: 2023-11-22
- 0.1.4 - (2023-11-22) Fixed bug in list parameter
- 0.1.3 - (2023-11-03) Updated list of LogName items
- 0.1.2 - Updated EventTable variable and supporting code
- 0.1.1 - Added StartTime, EndTime, and Data parameters
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-winevent

## RELATED LINKS
