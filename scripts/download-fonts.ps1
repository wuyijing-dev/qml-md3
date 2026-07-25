# Downloads Roboto + Material Icons into resources/fonts for offline Md3 builds.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$fonts = Join-Path $root "resources\fonts"
New-Item -ItemType Directory -Force -Path $fonts | Out-Null

$downloads = @{
    "Roboto-Regular.ttf"              = "https://github.com/googlefonts/roboto/raw/main/src/hinted/Roboto-Regular.ttf"
    "Roboto-Medium.ttf"               = "https://github.com/googlefonts/roboto/raw/main/src/hinted/Roboto-Medium.ttf"
    "Roboto-Bold.ttf"                 = "https://github.com/googlefonts/roboto/raw/main/src/hinted/Roboto-Bold.ttf"
    "MaterialIcons-Regular.ttf"       = "https://github.com/google/material-design-icons/raw/master/font/MaterialIcons-Regular.ttf"
    "MaterialIconsOutlined-Regular.otf" = "https://github.com/google/material-design-icons/raw/master/font/MaterialIconsOutlined-Regular.otf"
}

foreach ($name in $downloads.Keys) {
    $out = Join-Path $fonts $name
    Write-Host "Downloading $name ..."
    Invoke-WebRequest -Uri $downloads[$name] -OutFile $out -UseBasicParsing
    Write-Host ("  OK {0:N0} bytes" -f (Get-Item $out).Length)
}

Write-Host "Done. Fonts in $fonts"
