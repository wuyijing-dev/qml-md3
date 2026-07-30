# Wrapper around packaging/cli.py (Windows). Prefer: python scripts/packaging/cli.py
$ErrorActionPreference = "Stop"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$py = Get-Command python -ErrorAction SilentlyContinue
if (-not $py) { $py = Get-Command python3 -ErrorAction SilentlyContinue }
if (-not $py) { throw "python not found in PATH" }
& $py.Source (Join-Path $Root "scripts\packaging\cli.py") @args
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
