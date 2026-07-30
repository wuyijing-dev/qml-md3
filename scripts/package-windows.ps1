# Legacy wrapper — use: python scripts/package.py
$ErrorActionPreference = "Stop"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$py = Get-Command python -ErrorAction SilentlyContinue
if (-not $py) { $py = Get-Command python3 -ErrorAction SilentlyContinue }
if (-not $py) { throw "python not found in PATH" }
& $py.Source (Join-Path $Root "scripts\package.py") @args
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
