---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Write-Log

## SYNOPSIS
Create and/or write to a log file

## SYNTAX

### log (Default)
```
Write-Log -Path <String> -Type <String> -Message <String> [-ComputerName <String>] [<CommonParameters>]
```

### initialize
```
Write-Log -Directory <String> -Name <String> [-Frequency <String>] [<CommonParameters>]
```

## DESCRIPTION
This function has the ability to create and/or add entries to a log file. Notice it has two parameter sets (i.e., "initialize" and "log") depending on the intended use.

## EXAMPLES

### Example 1
```powershell
PS C:\> $LogFile = Write-Log -Directory "D:\Logs\BackupLogs" -Name Backups
```

Create logfile named Backups in D:\Logs\BackupLogs

### Example 2
```powershell
PS C:\> Write-Log -Path $LogFile -Message 'No data found' -Type Error
```

Write Error message "No data found" to $LogFile

## PARAMETERS

### -ComputerName
Source of log message

```yaml
Type: String
Parameter Sets: log
Aliases: CN

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Directory
Folder where log should be created

```yaml
Type: String
Parameter Sets: initialize
Aliases: Dir, D

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Frequency
New log file creation frequency

```yaml
Type: String
Parameter Sets: initialize
Aliases: F
Accepted values: Daily, Monthly, Yearly

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
Log entry message

```yaml
Type: String
Parameter Sets: log
Aliases: M

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Log name

```yaml
Type: String
Parameter Sets: initialize
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Log file path

```yaml
Type: String
Parameter Sets: log
Aliases: P

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Log entry type

```yaml
Type: String
Parameter Sets: log
Aliases: T
Accepted values: Info, Error, Warning, Debug

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### None

## NOTES

## RELATED LINKS
