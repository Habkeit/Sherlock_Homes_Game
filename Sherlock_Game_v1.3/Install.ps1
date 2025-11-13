# Set UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SHERLOCK HOLMES: THE PURSUIT GAME" -ForegroundColor Green  
Write-Host "  First Time Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get paths
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$exePath = Join-Path $scriptPath "Sherlock.exe"
$iconPath = Join-Path $scriptPath "icon.ico"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "Sherlock Holmes - The Pursuit Game.lnk"
$installedFile = Join-Path $scriptPath ".installed"

# Check if already installed
if (Test-Path $installedFile) {
    Write-Host "Already installed! Launching game..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process $exePath
    exit
}

Write-Host "Creating desktop shortcut..." -ForegroundColor Cyan
Write-Host "Desktop: $desktopPath" -ForegroundColor Gray
Write-Host ""

try {
    # Create shortcut
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $exePath
    $Shortcut.WorkingDirectory = $scriptPath
    $Shortcut.IconLocation = $iconPath
    $Shortcut.Description = "Sherlock Holmes: The Pursuit Game"
    $Shortcut.Save()
    
    # Mark as installed
    "installed" | Out-File -FilePath $installedFile -Encoding ASCII
    
    Write-Host "[SUCCESS] Desktop shortcut created!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Starting game in 2 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    
    Start-Process $exePath
    
} catch {
    Write-Host "[ERROR] Failed to create shortcut: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to launch game anyway..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Start-Process $exePath
}