# Install-GitHubModule

## SYNOPSIS
Install PowerShell module from GitHub repository

## SYNTAX

```
Install-GitHubModule [-Account] <String> [-Repository] <String> [[-Scope] <String>] [<CommonParameters>]
```

## DESCRIPTION
Install PowerShell module from GitHub repository

## EXAMPLES

### EXAMPLE 1
```
Install-GitHubModule -Account 'johnsarie27' -Repository 'SecurityTools'
Installs SecurityTools module in the CurrentUser scope
```

## PARAMETERS

### -Account
GitHub account or organization name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Repository
Repository name

```yaml
Type: String
Parameter Sets: (All)
Aliases: Repo

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
Module scope

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: CurrentUser
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
Name:     Install-GitHubModule
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-01-02
- 0.1.0 - Initial version
Comments:

## RELATED LINKS
