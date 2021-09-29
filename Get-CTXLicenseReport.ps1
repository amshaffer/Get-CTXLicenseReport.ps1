#Requires -Version 5.1

<#
.SYNOPSIS
    Get-CTXLicenseReport.ps1 returns Citrix licensing information.

.DESCRIPTION
    Get-CTXLicenseReport.ps1 retrieves Citrix licensing data from WMI and returns an an array containing objects of the available Citrix licenses. Each object will contain the product code, license type, total installed, total used, total free, and a used percentage.

.EXAMPLE
    PS> .\Get-CTXLicenseReport.ps1

    Product     : XDT_PLT_UD
    LicenseType : RetailS
    Installed   : 500
    Used        : 400
    Free        : 100
    Used%       : 80

.EXAMPLE
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

.EXAMPLE
    PS> $licenses = .\Get-CTXLicenseReport.ps1 -licenseServer "corp-ctx-lic.corp.com"
    PS> $licenses | Export-Csv -NoTypeInformation -Path CTXLicenseReport.csv

.PARAMETER licenseServer
    Specifies the Citrix license server to connect to. Defaults to localhost if left blank. Parameter is optional.

.OUTPUTS
    System.Array containing PSCustomObject(s) of each installed license. You may store the output in a variable and iterate through the license data as desired.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)][string]$licenseServer = "localhost"
)

try {
    $licensePool = Get-WmiObject  -Class "Citrix_GT_License_Pool" -ComputerName $licenseServer -Namespace "root\CitrixLicensing" -ErrorAction Stop
}
catch {
    Write-Warning $_.Exception.Message
    Write-Host "Unable to retrieve Citrix license information from $licenseServer. Please verify server is accessible for WMI query and that the server is the Citrix license server and retry."
    exit 5
}

$licenseInfo = $licensePool | Select-Object `
    @{Name = "Product"; Expression = { $_.PLD } },
    @{Name = "LicenseType"; Expression = { $_.LicenseType } },
    @{Name = "Installed"; Expression = { $_.Count } },
    @{Name = "Used"; Expression = { $_.InUseCount } },
    @{Name = "Free"; Expression = { $_.PooledAvailable } },
    @{Name = "Used%"; Expression = { [Math]::Round((($_.InUseCount / $_.Count) * 100), 2) } } |
    # Remove the Citrix License Server system license from the report
    Where-Object { $_.LicenseType -ne "SYS" } |
    Sort-Object Product

return $licenseInfo
