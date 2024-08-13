# Get-MsiInfo

## SYNOPSIS
Get MSI information

## SYNTAX

```
Get-MsiInfo [-Path] <FileInfo> [<CommonParameters>]
```

## DESCRIPTION
Get information from MSI file

## EXAMPLES

### EXAMPLE 1
```
Get-MsiInfo -Path "C:\myMsi.msi"
Returns all available product info for myMsi.msi
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
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
General notes
This function was originally written by Nickolaj Andersen (see link below)
https://www.scconfigmgr.com/2014/08/22/how-to-get-msi-file-information-with-powershell/
https://pscode.dev/get-msifileinfo

## RELATED LINKS
