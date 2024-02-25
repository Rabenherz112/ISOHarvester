<#
    .SYNOPSIS
    ISOHarvester; Downloads the latest ISO from the defined OS and store them locally

    .DESCRIPTION
    Download the latest (or specific) version of an OS ISO from the internet and store it locally. This script is designed to be run on a schedule to keep the local ISOs up to date.
    Currently supported OSs are:
    - Debian
    - Ubuntu
    - CentOS
    - Fedora
    - OpenSUSE
    - Manjaro
    - Arch
    - Kali
    - Raspbian
    - Elementary
    - Mint

    .EXAMPLE
    Run ther interactive mode
    .\GetLatestISO.ps1

    .NOTES
    Created by Rabenherz112

    .LINK
    https://github.com/Rabenherz112/
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string[]]$Functions
)

$Global:UserArguments = $Functions

Clear-Host
#$VerbosePreference = 'SilentlyContinue'
#$ErrorActionPreference = 'SilentlyContinue'
#$WarningPreference = 'SilentlyContinue'
#$InformationPreference = 'SilentlyContinue'
#$DebugPreference = 'SilentlyContinue'
$Host.UI.RawUI.WindowTitle = "ISOHarvester - Get the latest ISOs"

$modulePath = "$PSScriptRoot\resources"
$modules = Get-ChildItem -Path $modulePath -Filter "M_*.psm1" -File
foreach ($module in $modules) {
    Remove-Module -Name $module.BaseName -ErrorAction Ignore
    Import-Module -Name $module.FullName -Force
}

if ($Functions) {
    # Don't run the interactive mode
    Invoke-Command -ScriptBlock {InitialChecks}
    foreach ($function in $Functions) {
        if (Get-Command -Name $function -CommandType Function -ErrorAction SilentlyContinue) {
            Invoke-Command -ScriptBlock {Invoke-Expression -Command $using:function} -ArgumentList $function
        } else {
            Write-Host -ForegroundColor Red "Function '$function' not found!"
        }
    }
    # PostActions and Errors will be executed at the end
    Invoke-Command -ScriptBlock {PostActions; Errors}
} else {
    # Run the interactive mode
    Invoke-Command -ScriptBlock {InitialChecks}
    Invoke-Command -ScriptBlock {InteractiveMode}
    # PostActions and Errors will be executed at the end
    Invoke-Command -ScriptBlock {PostActions; Errors}
}
