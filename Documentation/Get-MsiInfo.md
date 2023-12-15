# Get-MsiInfo

## SYNOPSIS
Get MSI information

## SYNTAX

```
Get-MsiInfo [-Path] <FileInfo> [-Property] <String> [<CommonParameters>]
```

## DESCRIPTION
Get specific MSI property information

## EXAMPLES

### EXAMPLE 1
```
Get-MsiInfo -Path "C:\myMsi.msi" -Property ProductCode
Returns the product code for myMsi.msi
```

## PARAMETERS

### -Path
Path to MSI file

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
Desired property to obtain from MSI Database

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### None.
## NOTES
General notes
This function was originally written by Nickolaj Andersen (see link below)
https://www.scconfigmgr.com/2014/08/22/how-to-get-msi-file-information-with-powershell/

## RELATED LINKS
