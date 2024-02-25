$Global:Errors

function CreateBanner {
    $banner = @"
    ___ ____   ___  _   _                           _            
    |_ _/ ___| / _ \| | | | __ _ _ ____   _____  ___| |_ ___ _ __ 
     | |\___ \| | | | |_| |/ _` | '__\ \ / / _ \/ __| __/ _ \ '__|
     | | ___) | |_| |  _  | (_| | |   \ V /  __/\__ \ ||  __/ |   
    |___|____/ \___/|_| |_|\__,_|_|    \_/ \___||___/\__\___|_|   
    
ISOHarvester - Get the latest ISOs
    
Version: 1.0
Date: 25.02.2024
Created by: Rabenherz112

"@
    Write-Output $banner
    Start-Sleep -Seconds 1
}

function InitialChecks {
    param (
        [Parameter(Mandatory=$false)]
        [switch]$IgnoreErrors
    )
    $Global:Errors.Clear()

    InitialLogging
    CreateBanner
}

Export-ModuleMember -Function * -Alias *
