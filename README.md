# Get-CTXLicenseReport.ps1

## Overview
Get-CTXLicenseReport.ps1 retrieves Citrix licensing data from WMI and returns an an array containing objects of the available Citrix licenses. Each object will contain the product code, license type, total installed, total used, total free, and a used percentage.

## Requirements
- PowerShell Version 5.1 or newer. Included by default in all modern Windows Operating Systems. See the [Official Microsoft Documentation](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-7.1) for more information.
- If running remotely, you will need to be able to communicate with the Citrix license server via WMI. See the [Official Microsoft Documentation](https://docs.microsoft.com/en-us/windows/win32/wmisdk/connecting-to-wmi-on-a-remote-computer) for more information.

## Usage and Examples

Return Citrix license report on the local system:

```
PS> .\Get-CTXLicenseReport.ps1

Product     : XDT_PLT_UD
LicenseType : RetailS
Installed   : 500
Used        : 400
Free        : 100
Used%       : 80
```

Return Citrix license report against a remote Citrix license server:

```
PS> .\Get-CTXLicenseReport.ps1 -licenseServer "corp-ctx-lic.corp.com"

Product     : XDT_PLT_UD
LicenseType : RetailS
Installed   : 500
Used        : 400
Free        : 100
Used%       : 80

Product     : XDT_PLT_UD
LicenseType : RetailS
Installed   : 100
Used        : 100
Free        : 0
Used%       : 100
```

Generate a Citrix license report on the local system and output to a CSV

```
PS> $licenses = .\Get-CTXLicenseReport.ps1 -licenseServer "corp-ctx-lic.corp.com"
PS> $licenses | Export-Csv -NoTypeInformation -Path CTXLicenseReport.csv
```


## Help

Use Get-Help to view the built-in help.

```
PS> Get-Help .\Get-CTXLicenseReport.ps1
PS> Get-Help .\Get-CTXLicenseReport.ps1 -examples
PS> Get-Help .\Get-CTXLicenseReport.ps1 -full
```
