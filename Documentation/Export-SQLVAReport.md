# Export-SQLVAReport

## SYNOPSIS
This function is used to scan SQL Server DBs for Vulnerabilities

## SYNTAX

```
Export-SQLVAReport [-ServerName] <String> [[-BaselinePath] <String>] [[-OutputDirectory] <String>] [-PassThru]
 [<CommonParameters>]
```

## DESCRIPTION
The script relies on the native Vulnerability Assessment scan tool imbedded
in SQL Server Management Studio 17.0 & up

## EXAMPLES

### EXAMPLE 1
```
Export-SQLVAReport.ps1 -SN MySQLServer -BP C:\Baselines -DP C:\Reports
This exports a scan report using SQL Vulnerability Assessment tool for the master
database on MySQLServer using the corresponding baseline file in C:\Baselines.
```

## PARAMETERS

### -ServerName
Name of SQL Server

```yaml
Type: String
Parameter Sets: (All)
Aliases: SN, Server

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -BaselinePath
Path to baseline file in JSON format

```yaml
Type: String
Parameter Sets: (All)
Aliases: BP, Baseline

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputDirectory
Path to output directory for new SQL Vulnerability Assessment reports

```yaml
Type: String
Parameter Sets: (All)
Aliases: DestinationPath

Required: False
Position: 3
Default value: D:\MSSQL-VA
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns path to directory containing new reports

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### System.String.
## NOTES
General notes
https://docs.microsoft.com/en-us/sql/relational-databases/security/sql-vulnerability-assessment?view=sql-server-2017

## RELATED LINKS
