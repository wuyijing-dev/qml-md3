# Downloads HarmonyOS Sans SC + Material Icons into resources/fonts for offline Md3 builds.
# HarmonyOS Sans: Huawei official package (free for commercial use).
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$fonts = Join-Path $root "resources\fonts"
New-Item -ItemType Directory -Force -Path $fonts | Out-Null

$iconDownloads = @{
    "MaterialIcons-Regular.ttf"           = "https://github.com/google/material-design-icons/raw/master/font/MaterialIcons-Regular.ttf"
    "MaterialIconsOutlined-Regular.otf"   = "https://github.com/google/material-design-icons/raw/master/font/MaterialIconsOutlined-Regular.otf"
}

foreach ($name in $iconDownloads.Keys) {
    $out = Join-Path $fonts $name
    Write-Host "Downloading $name ..."
    Invoke-WebRequest -Uri $iconDownloads[$name] -OutFile $out -UseBasicParsing
    Write-Host ("  OK {0:N0} bytes" -f (Get-Item $out).Length)
}

$zip = Join-Path $env:TEMP "HarmonyOS-Sans.zip"
$harmonyUrl = "https://developer.huawei.com/images/download/next/HarmonyOS-Sans.zip"
Write-Host "Downloading HarmonyOS Sans ..."
Invoke-WebRequest -Uri $harmonyUrl -OutFile $zip -UseBasicParsing

Add-Type -AssemblyName System.IO.Compression.FileSystem
$extract = Join-Path $env:TEMP "HarmonyOS-Sans-extract"
if (Test-Path $extract) { Remove-Item -Recurse -Force $extract }
[System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $extract)

$scMap = @{
    "HarmonyOS_SansSC_Regular.ttf" = "HarmonyOS Sans\HarmonyOS_SansSC\HarmonyOS_SansSC_Regular.ttf"
    "HarmonyOS_SansSC_Medium.ttf"  = "HarmonyOS Sans\HarmonyOS_SansSC\HarmonyOS_SansSC_Medium.ttf"
    "HarmonyOS_SansSC_Bold.ttf"    = "HarmonyOS Sans\HarmonyOS_SansSC\HarmonyOS_SansSC_Bold.ttf"
}
foreach ($destName in $scMap.Keys) {
    $src = Join-Path $extract $scMap[$destName]
    if (-not (Test-Path $src)) { throw "Missing in zip: $($scMap[$destName])" }
    Copy-Item -Force $src (Join-Path $fonts $destName)
    Write-Host ("  OK {0} ({1:N0} bytes)" -f $destName, (Get-Item $src).Length)
}

# Remove legacy Roboto if present
foreach ($old in @("Roboto-Regular.ttf", "Roboto-Medium.ttf", "Roboto-Bold.ttf")) {
    $p = Join-Path $fonts $old
    if (Test-Path $p) { Remove-Item -Force $p; Write-Host "Removed $old" }
}

Write-Host "Done. Fonts in $fonts"
