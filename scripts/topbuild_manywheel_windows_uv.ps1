param(
    [ValidateSet('3.10', '3.11', '3.12', '3.13', '3.14', '3.15')]
    [string[]]$PythonVersions = @('3.10', '3.11', '3.12', '3.13', '3.14', '3.15'),
    [string]$OutputDirectory = 'dist'
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
ifx /QV

$originalPath = $env:PATH
foreach ($version in $PythonVersions) {
    $requirements = switch ($version) {
        '3.14' { 'build_requirement_3_14_windows.txt' }
        '3.15' { 'build_requirement_3_15_windows.txt' }
        default { 'build_requirement_windows.txt' }
    }

    Write-Host "Building Windows wheel for Python $version"
    $venv = [System.IO.Directory]::CreateTempSubdirectory('easyclimate-venv-')
    try {
        $pythonRequest = if ($version -eq '3.15') { '>=3.15.0,<3.16' } else { $version }
        uv venv $venv.FullName --python $pythonRequest
        $venvScripts = Join-Path $venv.FullName 'Scripts'
        $env:PATH = "$venvScripts;$originalPath"
        uv pip install --python (Join-Path $venvScripts 'python.exe') -r (Join-Path $PSScriptRoot $requirements)
        & (Join-Path $PSScriptRoot 'build_wheel_windows.ps1') -OutputDirectory $OutputDirectory
    }
    finally {
        $env:PATH = $originalPath
        Remove-Item -LiteralPath $venv.FullName -Recurse -Force
    }
}
