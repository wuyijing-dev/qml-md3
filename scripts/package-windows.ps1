# One-shot: build Md3 (library only), stage to dist\Md3, then install for the user.
#
# Usage:
#   .\scripts\package-windows.ps1
#   .\scripts\package-windows.ps1 -Shared:$false          # static
#   .\scripts\package-windows.ps1 -InstallPrefix "$env:LOCALAPPDATA\Md3"
#   .\scripts\package-windows.ps1 -CmakePrefixPath "D:\Qt\6.10.2\mingw_64"
#   .\scripts\package-windows.ps1 -SkipSystemInstall
#   .\scripts\package-windows.ps1 -CreateBundleDir "D:\path\to\Md3CreateDir"
#
# Outputs:
#   dist\Md3\                      staged package
#   dist\Md3-windows-<arch>-*.zip  optional archive
#   $InstallPrefix                 user/system install (default %LOCALAPPDATA%\Md3)

[CmdletBinding()]
param(
    [string]$Prefix = "",
    [string]$InstallPrefix = "",
    [string]$BuildDir = "",
    [string]$CmakePrefixPath = $env:CMAKE_PREFIX_PATH,
    [string]$BuildType = "Release",
    [string]$Generator = "",
    [int]$Jobs = 0,
    [string]$CreateBundleDir = "",
    [switch]$NoZip,
    [switch]$SkipSystemInstall,
    [bool]$Shared = $true
)

$ErrorActionPreference = "Stop"

function Write-Info([string]$msg) { Write-Host "==> $msg" }
function Die([string]$msg) { Write-Error $msg; exit 1 }

function Test-MsvcCompiler {
    return $null -ne (Get-Command cl -ErrorAction SilentlyContinue)
}

function Test-MsvcQtKit([string]$QtPrefix) {
    return ($QtPrefix -match 'msvc\d+')
}

function Find-VcVars64 {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path $vswhere) {
        $install = & $vswhere -latest -products * `
            -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
            -property installationPath 2>$null
        if ($install) {
            $vcvars = Join-Path $install.Trim() "VC\Auxiliary\Build\vcvars64.bat"
            if (Test-Path $vcvars) { return $vcvars }
        }
    }
    foreach ($root in @(
            "D:\vsproduct",
            "C:\Program Files\Microsoft Visual Studio\2022\Community",
            "C:\Program Files\Microsoft Visual Studio\2022\Professional",
            "C:\Program Files\Microsoft Visual Studio\2022\Enterprise",
            "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
        )) {
        $vcvars = Join-Path $root "VC\Auxiliary\Build\vcvars64.bat"
        if (Test-Path $vcvars) { return $vcvars }
    }
    return $null
}

function Import-MsvcDevEnvironment([string]$VcVars64) {
    Write-Info "Loading MSVC environment: $VcVars64"
    cmd /c "`"$VcVars64`" >nul 2>&1 && set" | ForEach-Object {
        if ($_ -match '^(.*?)=(.*)$') {
            Set-Item -Path "env:$($matches[1])" -Value $matches[2]
        }
    }
    if (-not (Test-MsvcCompiler)) {
        Die "Failed to load MSVC (cl.exe still not found after vcvars64)."
    }
}

function Ensure-MsvcForQt([string]$QtPrefix) {
    if (-not (Test-MsvcQtKit $QtPrefix) -or (Test-MsvcCompiler)) {
        return
    }
    $vcvars = Find-VcVars64
    if (-not $vcvars) {
        Die @"
Qt kit is MSVC ($QtPrefix) but cl.exe is not in PATH and Visual Studio C++ tools were not found.
Install 'Desktop development with C++' (VS 2022 or Build Tools), or pass -CmakePrefixPath to a MinGW Qt kit.
"@
    }
    Import-MsvcDevEnvironment $vcvars
}

$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$StagePrefix = Join-Path $Root "dist\Md3"
if (-not $Prefix) { $Prefix = $StagePrefix }
if (-not $InstallPrefix) { $InstallPrefix = Join-Path $env:LOCALAPPDATA "Md3" }
if (-not $BuildDir) { $BuildDir = Join-Path $Root "build-lib" }
if ($Jobs -le 0) { $Jobs = [Math]::Max(1, [Environment]::ProcessorCount) }

# If -Prefix points at a "system-like" path, use it as InstallPrefix and keep stage in dist\Md3
if ($Prefix -and ($Prefix -ne $StagePrefix) -and ($Prefix -notlike "*\dist\Md3")) {
    # Keep explicit -Prefix as stage unless user only wanted install location via -InstallPrefix
}

function Find-QtPrefix {
    if ($CmakePrefixPath -and (Test-Path (Join-Path ($CmakePrefixPath -split ";")[0] "lib\cmake\Qt6\Qt6Config.cmake"))) {
        return ($CmakePrefixPath -split ";")[0]
    }
    foreach ($name in @("qmake", "qmake6", "qtpaths", "qtpaths6")) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) {
            if ($name -like "qtpaths*") {
                $p = & $cmd.Source --install-prefix 2>$null
            } else {
                $p = & $cmd.Source -query QT_INSTALL_PREFIX 2>$null
            }
            if ($p -and (Test-Path (Join-Path $p.Trim() "lib\cmake\Qt6\Qt6Config.cmake"))) {
                return $p.Trim()
            }
        }
    }
    $roots = @("D:\Qt", "C:\Qt", "$env:USERPROFILE\Qt")
    foreach ($r in $roots) {
        if (-not (Test-Path $r)) { continue }
        Get-ChildItem $r -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match '^\d+\.\d+' } |
            Sort-Object Name -Descending |
            ForEach-Object {
                foreach ($kit in @("mingw_64", "msvc2022_64", "msvc2019_64")) {
                    $cand = Join-Path $_.FullName $kit
                    if (Test-Path (Join-Path $cand "lib\cmake\Qt6\Qt6Config.cmake")) {
                        return $cand
                    }
                }
            }
    }
    return $null
}

if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Die "cmake not found in PATH"
}

if (-not $Generator) {
    if (Get-Command ninja -ErrorAction SilentlyContinue) {
        $Generator = "Ninja"
    } else {
        $Generator = "Ninja"
        Write-Info "Ninja not found in PATH — still requesting Ninja (install or pass -Generator)"
    }
}

$QtPrefix = Find-QtPrefix
if (-not $QtPrefix) {
    Die "Qt6 not found. Pass -CmakePrefixPath (e.g. D:\Qt\6.10.2\mingw_64)."
}

$SharedOn = if ($Shared) { "ON" } else { "OFF" }
$SharedLabel = if ($Shared) { "shared" } else { "static" }

Write-Info "ROOT           = $Root"
Write-Info "BUILD_DIR      = $BuildDir"
Write-Info "STAGE          = $Prefix"
Write-Info "InstallPrefix  = $InstallPrefix"
Write-Info "SHARED         = $SharedOn ($SharedLabel)"
Write-Info "Qt             = $QtPrefix"
Write-Info "Generator      = $Generator ($Jobs jobs, $BuildType)"

Ensure-MsvcForQt $QtPrefix

Write-Info "Clean build dir"
if (Test-Path $BuildDir) { Remove-Item -Recurse -Force $BuildDir }

Write-Info "Configure"
& cmake -S $Root -B $BuildDir -G $Generator `
    -DMD3_BUILD_GALLERY=OFF `
    "-DMD3_BUILD_SHARED=$SharedOn" `
    "-DCMAKE_BUILD_TYPE=$BuildType" `
    "-DCMAKE_INSTALL_PREFIX=$Prefix" `
    "-DCMAKE_PREFIX_PATH=$QtPrefix"
if ($LASTEXITCODE -ne 0) { Die "cmake configure failed" }

Write-Info "Build"
& cmake --build $BuildDir --parallel $Jobs --config $BuildType
if ($LASTEXITCODE -ne 0) { Die "cmake build failed" }

Write-Info "Stage -> $Prefix"
if (Test-Path $Prefix) { Remove-Item -Recurse -Force $Prefix }
& cmake --install $BuildDir --prefix $Prefix --config $BuildType
if ($LASTEXITCODE -ne 0) { Die "cmake stage install failed" }

$inc = Join-Path $Prefix "include\Md3"
$cmakeCfg = Join-Path $Prefix "lib\cmake\Md3"
if (-not (Test-Path $inc)) { Die "missing include\Md3 after stage" }
if (-not (Test-Path $cmakeCfg)) { Die "missing lib\cmake\Md3 after stage" }

$libHit = $null
$candidates = if ($Shared) {
    @("libMd3.dll.a", "Md3.lib", "libMd3.so", "Md3.dll")
} else {
    @("libMd3.a", "libMd3.lib", "Md3.lib", "libMd3.dll.a")
}
foreach ($n in $candidates) {
    $p = Join-Path $Prefix "lib\$n"
    if (Test-Path $p) { $libHit = $p; break }
}
# DLL may land in bin/
if (-not $libHit -and $Shared) {
    foreach ($n in @("Md3.dll", "libMd3.dll")) {
        $p = Join-Path $Prefix "bin\$n"
        if (Test-Path $p) { $libHit = $p; break }
    }
}
if (-not $libHit) { Die "missing libMd3 under $Prefix\lib (or bin) for $SharedLabel build" }

$readme = @"
# Md3 packaged library (Windows, $SharedLabel)

Built by ``scripts/package-windows.ps1`` from QML_MD3.

## Layout

| Path | Content |
|------|---------|
| ``lib\`` / ``bin\`` | Core library ($SharedLabel) + plugin |
| ``lib\Md3\stubs\`` | Static init sources (static builds) |
| ``lib\qml\Md3\`` | qmldir / qmltypes |
| ``lib\cmake\Md3\`` | find_package(Md3) |
| ``include\Md3\`` | C++ headers |

## System / user install

Default install prefix: ``$InstallPrefix``

``````cmake
list(APPEND CMAKE_PREFIX_PATH "$InstallPrefix")
find_package(Md3 REQUIRED)
target_link_libraries(yourApp PRIVATE Md3::Md3)
``````

For shared builds, ensure DLLs are on PATH or beside the executable.

## Use with Md3 Create

Place this folder next to ``Md3Create.exe`` as sibling ``Md3\``.

Qt used: ``$QtPrefix``
"@
Set-Content -Path (Join-Path $Prefix "README.md") -Value $readme -Encoding UTF8

Write-Info "Stage ready: $Prefix ($SharedLabel)"
Get-ChildItem (Join-Path $Prefix "lib") -ErrorAction SilentlyContinue | Select-Object Name, Length | Format-Table -AutoSize
Get-ChildItem (Join-Path $Prefix "bin") -ErrorAction SilentlyContinue | Select-Object Name, Length | Format-Table -AutoSize

if (-not $SkipSystemInstall) {
    Write-Info "Install -> $InstallPrefix"
    if (Test-Path $InstallPrefix) { Remove-Item -Recurse -Force $InstallPrefix }
    New-Item -ItemType Directory -Force -Path (Split-Path $InstallPrefix -Parent) | Out-Null
    Copy-Item -Recurse -Force $Prefix $InstallPrefix
    Write-Info "User install done: $InstallPrefix"
} else {
    Write-Info "SkipSystemInstall — staged only at $Prefix"
}

if (-not $NoZip) {
    $arch = $env:PROCESSOR_ARCHITECTURE
    if (-not $arch) { $arch = "x64" }
    $zip = Join-Path $Root "dist\Md3-windows-$arch-$SharedLabel.zip"
    New-Item -ItemType Directory -Force -Path (Join-Path $Root "dist") | Out-Null
    if (Test-Path $zip) { Remove-Item -Force $zip }
    Compress-Archive -Path $Prefix -DestinationPath $zip
    Write-Info "Archive: $zip"
}

if ($CreateBundleDir) {
    $bundleMd3 = Join-Path $CreateBundleDir "Md3"
    Write-Info "Copy package -> $bundleMd3 (fixed name for Md3Create)"
    New-Item -ItemType Directory -Force -Path $CreateBundleDir | Out-Null
    if (Test-Path $bundleMd3) { Remove-Item -Recurse -Force $bundleMd3 }
    Copy-Item -Recurse -Force $Prefix $bundleMd3
    Write-Info "Bundle Md3 ready. Put Md3Create.exe in: $CreateBundleDir"
}

Write-Info "Done ($SharedLabel)."
Write-Host "  staged:       $Prefix"
if (-not $SkipSystemInstall) {
    Write-Host "  installed:    $InstallPrefix"
    Write-Host "  find_package: list(APPEND CMAKE_PREFIX_PATH `"$InstallPrefix`")"
    if ($Shared) {
        Write-Host "  runtime:      add $InstallPrefix\bin to PATH (or copy DLLs beside exe)"
    }
} else {
    Write-Host "  find_package: list(APPEND CMAKE_PREFIX_PATH `"$Prefix`")"
}
