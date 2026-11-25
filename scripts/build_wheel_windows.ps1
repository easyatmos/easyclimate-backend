param(
    [string]$OutputDirectory = 'dist'
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
$env:CC = 'cl'
$env:FC = 'ifx'

python -m build --wheel --no-isolation --outdir $OutputDirectory
