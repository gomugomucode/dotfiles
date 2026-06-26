# 1. Linux 'rm -rf' command wrapper
function rm_linux {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        $ArgsList
    )
    if ($ArgsList -contains '-rf' -or $ArgsList -contains '-fr') {
        $CleanedArgs = $ArgsList | Where-Object { $_ -ne '-rf' -and $_ -ne '-fr' }
        Remove-Item -Recurse -Force $CleanedArgs
    } else {
        Remove-Item @ArgsList
    }
}
if (Get-Alias rm -ErrorAction SilentlyContinue) { Remove-Item alias:rm }
Set-Alias rm rm_linux

# 2. Linux 'touch' command (Fixed to accept direct filename arguments)
function touch {
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [string[]]$Path
    )
    process {
        foreach ($file in $Path) {
            if (Test-Path $file) {
                (Get-Item $file).LastWriteTime = Get-Date
            } else {
                New-Item -ItemType File -Path $file -Force | Out-Null
            }
        }
    }
}

# 3. Linux 'clear' command
Set-Alias clear Clear-Host

# 4. Linux 'grep' command
function grep {
    param([string]$Pattern)
    $Input | Select-String -Pattern $Pattern
}

# 5. Linux 'whoami' fallback 
# (Windows has a native 'whoami.exe', this ensures it runs correctly without extensions)
function whoami_linux {
    whoami.exe
}
if (Get-Alias whoami -ErrorAction SilentlyContinue) { Remove-Item alias:whoami }
Set-Alias whoami whoami_linux

# 6. Linux 'ls' with flag supports (like ls -la, ls -l)
function ls_linux {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        $ArgsList
    )
    # Check if user wants a detailed/hidden list like -la, -al, or -a
    if ($ArgsList -contains '-la' -or $ArgsList -contains '-al' -or $ArgsList -contains '-a') {
        Get-ChildItem -Force
    } elseif ($ArgsList -contains '-l') {
        Get-ChildItem
    } else {
        # Default behavior: clean layout similar to Linux names
        (Get-ChildItem).Name
    }
}
if (Get-Alias ls -ErrorAction SilentlyContinue) { Remove-Item alias:ls }
Set-Alias ls ls_linux

# 7. Linux 'pwd' command
function pwd_linux {
    (Get-Location).Path
}
if (Get-Alias pwd -ErrorAction SilentlyContinue) { Remove-Item alias:pwd }
Set-Alias pwd pwd_linux

# 8. Linux 'mv' and 'cp' commands (Simple aliases)
if (Get-Alias mv -ErrorAction SilentlyContinue) { Remove-Item alias:mv }
Set-Alias mv Move-Item

if (Get-Alias cp -ErrorAction SilentlyContinue) { Remove-Item alias:cp }
Set-Alias cp Copy-Item


# Quick git shortcut to add, commit, and push in one go
# Usage: gsync "fixed the bug"
function gsync {
    param([string]$message)
    git add .
    git commit -m $message
    git push
}

# Open the current directory in VS Code instantly
# Usage: c.
function c. {
    code .
}

# Find what process is locking a specific local port
# Usage: checkport 3000
function checkport {
    param([int]$port)
    Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess
}


# ==========================================
# 9. Predictive Typing (Zsh/Fish-style)
# ==========================================
# Enable history-based predictive typing (grayed out text previews)
Set-PSReadLineOption -PredictionSource History
# Use the Right Arrow key to instantly accept the preview suggestion
Set-PSReadLineOption -PredictionViewStyle InlineView

# ==========================================
# 10. Custom Login Greeting with System Specs
# ==========================================
function Show-WelcomeGreeting {
    Clear-Host
    $OS = (Get-CimInstance Win32_OperatingSystem).Caption
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $Time = Get-Date -Format "dddd, MMMM dd, yyyy hh:mm tt"
    
    # Calculate RAM
    $CompSystem = Get-CimInstance Win32_ComputerSystem
    $TotalRAM = [Math]::Round($CompSystem.TotalPhysicalMemory / 1GB, 0)
    
    # Calculate Disk Space for C:
    $DriveC = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $FreeSpace = [Math]::Round($DriveC.FreeSpace / 1GB, 1)
    $Size = [Math]::Round($DriveC.Size / 1GB, 0)

    # Print Greeting UI
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "  Welcome back, $User!" -ForegroundColor Green
    Write-Host "  $Time" -ForegroundColor DarkGray
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "  OS:       $OS" -ForegroundColor White
    Write-Host "  RAM:      $TotalRAM GB installed" -ForegroundColor White
    Write-Host "  Storage:  C:\ $FreeSpace GB free / $Size GB total" -ForegroundColor White
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "  Tip: Type a command and use [Right Arrow] to auto-complete!" -ForegroundColor Yellow
    Write-Host ""
}

# Run the greeting automatically upon launch
Show-WelcomeGreeting

# ==========================================
# 11. Network Shortcuts (IP & Ping Utilities)
# ==========================================

# Sthand shortcut to quickly fetch the active local IPv4 address
function myip {
    # Filters active network cards to isolate the operational local IPv4 string
    Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred | 
        Where-Object { $_.InterfaceAlias -notmatch 'Loopback|VirtualBox|vEthernet|VMware' } | 
        Select-Object -ExpandProperty IPAddress
}

# Advanced ping utility that checks response latency
# Usage: pingt           (defaults to google.com)
# Usage: pingt github.com
function pingt {
    param(
        [string]$Target = "google.com"
    )
    Write-Host "Testing connectivity and latency to $Target... (Press Ctrl+C to stop)" -ForegroundColor Yellow
    # Triggers native ping tool cleanly into the terminal stream
    ping.exe $Target
}

