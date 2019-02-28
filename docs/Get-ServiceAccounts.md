---
external help file: SecurityTools-help.xml
Module Name: SecurityTools
online version:
schema: 2.0.0
---

# Get-ServiceAccounts

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Get-ServiceAccounts [-Environment] <String> [-Agency] <String> [-DomainName] <String>
 [-ConfigurationData] <String> [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Agency
Agency

```yaml
Type: String
Parameter Sets: (All)
Aliases: Customer

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigurationData
Configuration data file

```yaml
Type: String
Parameter Sets: (All)
Aliases: ConfigFile, DataFile, CofnigData, File, Path

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainName
Domain short name

```yaml
Type: String
Parameter Sets: (All)
Aliases: Domain

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Environment
Environment

```yaml
Type: String
Parameter Sets: (All)
Aliases: Env, System
Accepted values: PRD, STG

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
