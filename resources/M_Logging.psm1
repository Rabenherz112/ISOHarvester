function InitialLogging {
    # Check if user defined -logPath if it's a valid path
    if ($Global:UserArguments -contains "-logPath") {
        $logPath = $Global:UserArguments[$Global:UserArguments.IndexOf("-logPath") + 1]
        if (Test-Path -Path $logPath -PathType Container) {
            $logFile = "$logPath\$(Get-Date -Format 'yyyy-MM-dd_HH-mm')_ISOHarvester.log"
        } else {
            Write-Output "ERROR: Log path '$logPath' not found!"
            Exit
        }
    } else {
        if (-not (Test-Path -Path "$PSScriptRoot\logs" -PathType Container)) {
            New-Item -Path "$PSScriptRoot\logs" -ItemType Directory | Out-Null
        }
        $logFile = "$PSScriptRoot\logs\$(Get-Date -Format 'yyyy-MM-dd_HH-mm')_ISOHarvester.log"
    }
    # Check if user defined -logLevel and if it's a valid level
    if ($Global:UserArguments -contains "-logLevel") {
        $logLevel = $Global:UserArguments[$Global:UserArguments.IndexOf("-logLevel") + 1]
        if ($logLevel -ge 0 -and $logLevel -le 4) {
            $logLevel = $logLevel
        } else {
            Write-Output "ERROR: Log level '$logLevel' not valid!"
            Exit
        }
    } else {
        $logLevel = 1
    }

    # Create the log file if it doesn't exist
    if (-not (Test-Path -Path $logFile -PathType Leaf)) {
        New-Item -Path $logFile -ItemType File | Out-Null
    }
    $Global:LogFile = $logFile
    $Global:LogLevel = $logLevel
}

function WriteLog {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$false)]
        [int]$Level,
        [Parameter(Mandatory=$false)]
        [switch]$NoNewLine,
        [Parameter(Mandatory=$false)]
        [switch]$NoFile,
        [Parameter(Mandatory=$false)]
        [switch]$NoConsole
    )
    # Check if the log level is valid and set, if not set it to 1
    if (-not $Level -or $Level -lt 0 -or $Level -gt 4) {
        $Level = 1
    }
    $LevelText = @{
        0 = "DEBUG"
        1 = "INFO"
        2 = "WARNING"
        3 = "ERROR"
        4 = "FATAL"
    }
    # Return if the level is lower than the global log level
    if ($Level -lt $Global:LogLevel) {
        return
    }
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    if (!$NoFile) {
        $logEntry = "[$timestamp] [$($LevelText[$Level])] $Message"
        Add-Content -Path $Global:LogFile -Value $logEntry
    }
    if (!$NoConsole) {
        Write-Host "[$timestamp] " -NoNewline
        switch ($Level) {
            0 {Write-Host -ForegroundColor Magenta "[$($LevelText[$Level])] $Message" -NoNewline}
            1 {Write-Host -ForegroundColor Blue "[$($LevelText[$Level])] $Message" -NoNewline}
            2 {Write-Host -ForegroundColor Yellow "[$($LevelText[$Level])] $Message" -NoNewline}
            3 {Write-Host -ForegroundColor Red "[$($LevelText[$Level])] $Message" -NoNewline}
            4 {Write-Host -ForegroundColor DarkRed "[$($LevelText[$Level])] $Message" -NoNewline}
        }
        if (!$NoNewLine) {
            Write-Host ""
        }
    }
}

Export-ModuleMember -Function * -Alias *
