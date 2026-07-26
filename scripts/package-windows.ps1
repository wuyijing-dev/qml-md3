# One-shot: build Md3 (library only) and package into a standalone folder on Windows.
#
# Usage:
#   .\scripts\package-windows.ps1
#   .\scripts\package-windows.ps1 -Prefix "D:\opt\Md3" -CmakePrefixPath "D:\Qt\6.10.2\mingw_64"
#   .\scripts\package-windows.ps1 -CreateBundleDir "D:\QML_MD3\md3-create\dist-bundle"
#
# Output (default):
#   dist\Md3\
#     lib\libMd3.a / Md3.lib
#     lib\libMd3plugin.a
#     lib\qml\Md3\
#     lib\cmake\Md3\          Md3Config.cmake
#     lib\Md3\stubs\
#     include\Md3\
#   dist\Md3-windows-<arch>.zip
#
# With -CreateBundleDir, also copies the package next to Md3Create as:
#   <CreateBundleDir>\Md3\     (fixed sibling name for the wizard)

[CmdletBinding()]
param(
    [string]$Prefix = "",
    [string]$BuildDir = "",
    [string]$CmakePrefixPath = $env:CMAKE_PREFIX_PATH,
    [string]$BuildType = "Release",
    [string]$Generator = "",
    [int]$Jobs = 0,
    [string]$CreateBundleDir = "",
    [switch]$NoZip
)

$ErrorActionPreference = "Stop"

function Write-Info([string]$msg) { Write-Host "==> $msg" }
function Die([string]$msg) { Write-Error $msg; exit 1 }

$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if (-not $Prefix) { $Prefix = Join-Path $Root "dist\Md3" }
if (-not $BuildDir) { $BuildDir = Join-Path $Root "build-lib" }
if ($Jobs -le 0) { $Jobs = [Math]::Max(1, [Environment]::ProcessorCount) }

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

Write-Info "ROOT      = $Root"
Write-Info "BUILD_DIR = $BuildDir"
Write-Info "PREFIX    = $Prefix"
Write-Info "Qt        = $QtPrefix"
Write-Info "Generator = $Generator ($Jobs jobs, $BuildType)"

Write-Info "Configure"
& cmake -S $Root -B $BuildDir -G $Generator `
    -DMD3_BUILD_GALLERY=OFF `
    "-DCMAKE_BUILD_TYPE=$BuildType" `
    "-DCMAKE_INSTALL_PREFIX=$Prefix" `
    "-DCMAKE_PREFIX_PATH=$QtPrefix"
if ($LASTEXITCODE -ne 0) { Die "cmake configure failed" }

Write-Info "Build"
& cmake --build $BuildDir --parallel $Jobs --config $BuildType
if ($LASTEXITCODE -ne 0) { Die "cmake build failed" }

Write-Info "Install -> $Prefix"
if (Test-Path $Prefix) { Remove-Item -Recurse -Force $Prefix }
& cmake --install $BuildDir --prefix $Prefix --config $BuildType
if ($LASTEXITCODE -ne 0) { Die "cmake install failed" }

$inc = Join-Path $Prefix "include\Md3"
$cmakeCfg = Join-Path $Prefix "lib\cmake\Md3"
if (-not (Test-Path $inc)) { Die "missing include\Md3 after install" }
if (-not (Test-Path $cmakeCfg)) { Die "missing lib\cmake\Md3 after install" }

$libHit = $null
foreach ($n in @("libMd3.a", "libMd3.lib", "Md3.lib", "libMd3.dll.a")) {
    $p = Join-Path $Prefix "lib\$n"
    if (Test-Path $p) { $libHit = $p; break }
}
if (-not $libHit) { Die "missing libMd3 under $Prefix\lib" }

$readme = @"
# Md3 packaged library (Windows)

Built by ``scripts/package-windows.ps1`` from QML_MD3.

## Layout

| Path | Content |
|------|---------|
| ``lib\libMd3.*`` / ``Md3.lib`` | Core library |
| ``lib\libMd3plugin.*`` | QML plugin |
| ``lib\Md3\stubs\`` | Static plugin / rcc init sources |
| ``lib\qml\Md3\`` | qmldir / qmltypes |
| ``lib\cmake\Md3\`` | find_package(Md3) |
| ``include\Md3\`` | C++ headers |

## Use with Md3 Create

Place this folder **next to** ``Md3Create.exe`` as a sibling named exactly ``Md3``:

``````
SomeFolder\
  Md3Create.exe
  Md3\          <-- this package (fixed name)
``````

The wizard copies ``Md3`` into each new app as ``<App>\Md3\``.

## CMake

``````cmake
list(APPEND CMAKE_PREFIX_PATH "\${CMAKE_CURRENT_SOURCE_DIR}/Md3")
find_package(Md3 REQUIRED)
target_link_libraries(yourApp PRIVATE Md3::Md3)
``````

Qt used: ``$QtPrefix``
"@
Set-Content -Path (Join-Path $Prefix "README.md") -Value $readme -Encoding UTF8

Write-Info "Package ready: $Prefix"
Get-ChildItem (Join-Path $Prefix "lib") | Select-Object Name, Length | Format-Table -AutoSize

if (-not $NoZip) {
    $arch = $env:PROCESSOR_ARCHITECTURE
    if (-not $arch) { $arch = "x64" }
    $zip = Join-Path $Root "dist\Md3-windows-$arch.zip"
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

Write-Info "Done."
Write-Host "  find_package: list(APPEND CMAKE_PREFIX_PATH `"$Prefix`")"
Write-Host "  Create sibling layout: <dir>\Md3Create.exe + <dir>\Md3\"
