<#
.SYNOPSIS
    STALKER 2 Shader & Frame Check — Read-Only Windows Diagnostic Script
.DESCRIPTION
    Performs non-invasive, read-only local checks on Windows (Steam paths, folder layout,
    file timestamps/sizes, and system info). Does NOT modify, delete, or upload any files,
    and does NOT require administrator privileges or changes to Windows Defender.
.NOTES
    License: MIT
#>

$ErrorActionPreference = 'SilentlyContinue'

function Get-SteamLibraries {
    $libs = @()
    $regPath = 'HKCU:\Software\Valve\Steam'
    $steamPath = (Get-ItemProperty -Path $regPath -Name 'SteamPath').SteamPath
    if (-not $steamPath) {
        $steamPath = 'C:\Program Files (x86)\Steam'
    }
    $steamPath = $steamPath -replace '/', '\'
    if (Test-Path $steamPath) {
        $libs += $steamPath
        $vdf = Join-Path $steamPath 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            $content = Get-Content -Path $vdf -Raw
            $matches = [regex]::Matches($content, '"path"\s+"([^"]+)"')
            foreach ($m in $matches) {
                $p = $m.Groups[1].Value -replace '\\', '\'
                if ((Test-Path $p) -and ($libs -notcontains $p)) {
                    $libs += $p
                }
            }
        }
    }
    return $libs
}

function Find-SteamGameDir {
    param([string[]]$FolderNames)
    foreach ($lib in (Get-SteamLibraries)) {
        foreach ($name in $FolderNames) {
            $candidate = Join-Path $lib "steamapps\common\$name"
            if (Test-Path $candidate) {
                return $candidate
            }
        }
    }
    return $null
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " STALKER 2 Shader & Frame Check (Read-Only Check)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$os = Get-CimInstance Win32_OperatingSystem
$gpu = Get-CimInstance Win32_VideoController | Select-Object -First 1
$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)

Write-Host "[System & GPU]" -ForegroundColor Yellow
Write-Host "  OS      : $($os.Caption) ($($os.Version))"
Write-Host "  RAM     : $ramGB GB"
Write-Host "  GPU     : $($gpu.Name) (Driver: $($gpu.DriverVersion))"
Write-Host ""

$savedDir = "$env:LOCALAPPDATA\Stalker2\Saved"
Write-Host "[Local Saved & Config Directory]" -ForegroundColor Yellow
if (Test-Path $savedDir) {
    Write-Host "  Path    : $savedDir" -ForegroundColor Green
    $cfgDir = Join-Path $savedDir "Config\Windows"
    if (Test-Path $cfgDir) {
        Get-ChildItem -Path $cfgDir -Filter "*.ini" | ForEach-Object {
            $kb = [math]::Round($_.Length / 1KB, 2)
            Write-Host ("    - {0,-28} | {1,7} KB | {2}" -f $_.Name, $kb, $_.LastWriteTime)
        }
    }
} else {
    Write-Host "  Not found at $savedDir" -ForegroundColor DarkYellow
}
Write-Host ""

$gameDir = Find-SteamGameDir -FolderNames @("S.T.A.L.K.E.R. 2 Heart of Chornobyl", "Stalker2")
Write-Host "[Steam Install & ~mods Check]" -ForegroundColor Yellow
if ($gameDir) {
    Write-Host "  Install : $gameDir" -ForegroundColor Green
    $modsDir = Join-Path $gameDir "Stalker2\Content\Paks\~mods"
    if (Test-Path $modsDir) {
        $paks = Get-ChildItem -Path $modsDir -File
        Write-Host "  ~mods   : $($paks.Count) file(s) present" -ForegroundColor Cyan
        foreach ($p in $paks) { Write-Host "    - $($p.Name)" }
    } else {
        Write-Host "  ~mods   : None detected"
    }
} else {
    Write-Host "  Game folder not found in default Steam libraries." -ForegroundColor DarkYellow
}

Write-Host ""
Write-Host "Diagnostic complete. No files were modified." -ForegroundColor Green
Read-Host "Press Enter to exit"
