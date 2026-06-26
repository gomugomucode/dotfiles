# 🚀 High-Productivity PowerShell Profile (Dotfiles)

A custom, streamlined configuration that transforms the standard Windows PowerShell environment into a fast, hybrid developer console blending essential Linux habits with helpful automation utilities.

## ✨ Core Features

*   **🐧 Linux Command Aliases**: Full support for standard utilities (`rm -rf`, `touch`, `ls -la`, `clear`, `grep`, `pwd`, `mv`, `cp`).
*   **🔮 Predictive Input**: Active command prediction matching historical user syntax. Complete strings instantly using the `[Right Arrow]` key.
*   **📊 Hardware Status Dashboard**: Displays an isolated system overview containing active system RAM and real-time available `C:\` partition space upon initialization.
*   **⚡ Dev Automation Macros**: Single-step remote Git synchronization (`gsync`), immediate VS Code workspace launching (`c.`), and rapid port blocker diagnostics (`checkport`).

---

## 🛠️ Automated Aliases & Shortcuts Reference

| Command | Native Equivalent / Purpose | Description |
| :--- | :--- | :--- |
| `rm -rf <path>` | `Remove-Item -Recurse -Force` | Deletes files/folders aggressively without parameter syntax errors. |
| `touch <file>` | `New-Item -ItemType File` | Creates blank files or updates an existing file's timestamp. |
| `ls -la` | `Get-ChildItem -Force` | Lists hidden dotfiles and directories cleanly. |
| `grep "<term>"` | `Select-String` | Filters stdout streams for matching data. |
| `gsync "<msg>"` | `git add/commit/push` | Stages, commits, and pushes your branch to upstream in one step. |
| `c.` | `code .` | Spawns a Visual Studio Code instance inside the active directory. |
| `checkport <id>`| `Get-NetTCPConnection` | Isolates system process IDs blocking targeted development ports. |
| `myip` | `Get-NetIPAddress` | Extracts your machine's active, operational IPv4 local network target. |
| `pingt <host>` | `ping.exe` | Rapid network response latency test wrapper (defaults to google.com). |

---
## 📦 1-Line Instant Installation

Open an administrative PowerShell window and run this single line to automatically download, install, authorize, and boot up this profile layout on any Windows machine:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; if (!(Test-Path PROFILE)) New-Item -Type File -Path PROFILE -Force }; Invoke-RestMethod -Uri "https://githubusercontent.com" | Out-File -FilePath \(PROFILE -Encoding utf8; &\)PROFILE
```


## 🚀 Standard Installation & Setup

To clone and link this profile configuration on any Windows machine:

1. **Verify your local PowerShell Profile location**:
   ```powershell
   echo \$PROFILE
   ```
2. **Back up or replace your existing profile**:
   Copy the script contents from `profile.ps1` in this repository and insert them directly into your file path using Notepad:
   ```powershell
   notepad \$PROFILE
   ```
3. **Authorize Local Script Execution**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
4. **Reload environment**:
   ```powershell
   & \$PROFILE
   ```
