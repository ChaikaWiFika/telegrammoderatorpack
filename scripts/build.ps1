param(
    [string]$BuildPath = "H:\ModTG",
    [string]$ApiId = "",
    [string]$ApiHash = "",
    [switch]$TestApi
)

$ErrorActionPreference = "Stop"

$PackRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $PackRoot "patches\prepare.py.diff"))) {
    throw "Run this script from the telegrammoderatorpack repository: scripts\build.ps1"
}

function Apply-Patch {
    param([string]$Repo, [string]$Patch)

    if (-not (Test-Path $Patch)) {
        throw "Patch not found: $Patch"
    }

    & git -C $Repo apply --reverse --check $Patch 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Already applied: $Patch"
        return
    }

    & git -C $Repo apply $Patch
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to apply: $Patch"
    }
    Write-Host "Applied: $Patch"
}

$git = (Get-Command git -ErrorAction SilentlyContinue).Source
if (-not $git) { $git = "C:\Program Files\Git\cmd\git.exe" }
if (-not (Test-Path $git)) { throw "git not found" }
$env:Path = (Split-Path $git) + ";" + $env:Path

$py314 = Join-Path $env:LOCALAPPDATA "Programs\Python\Python314"
if (Test-Path $py314) {
    $env:Path = $py314 + ";" + $env:Path
}
$python = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $python) { throw "python not found in PATH" }

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) { throw "vswhere not found" }
$vsPath = & $vswhere -latest -products * -property installationPath
if (-not $vsPath) { throw "Visual Studio not found" }
$vcvars = Join-Path $vsPath "VC\Auxiliary\Build\vcvars64.bat"
if (-not (Test-Path $vcvars)) { throw "vcvars64.bat not found: $vcvars" }

New-Item -ItemType Directory -Force -Path $BuildPath | Out-Null
$tdesktop = Join-Path $BuildPath "tdesktop"

if (-not (Test-Path $tdesktop)) {
    & git clone --recursive --branch v7.4.4 https://github.com/telegramdesktop/tdesktop.git $tdesktop
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
}

Apply-Patch -Repo $tdesktop -Patch (Join-Path $PackRoot "patches\prepare.py.diff")
Apply-Patch -Repo (Join-Path $tdesktop "cmake") -Patch (Join-Path $PackRoot "patches\run_cmake.py.diff")

$cmd = "call `"$vcvars`" -vcvars_ver=14.44 >nul && cd /d `"$BuildPath`" && `"$tdesktop\Telegram\build\prepare\win.bat`" patches"
& cmd.exe /c $cmd
if ($LASTEXITCODE -ne 0) { throw "prepare patches failed" }

Apply-Patch -Repo (Join-Path $BuildPath "Libraries\win64\patches") -Patch (Join-Path $PackRoot "patches\build_ffmpeg_win.sh.diff")

$cmd = "call `"$vcvars`" -vcvars_ver=14.44 >nul && cd /d `"$BuildPath`" && `"$tdesktop\Telegram\build\prepare\win.bat`" silent"
& cmd.exe /c $cmd
if ($LASTEXITCODE -ne 0) { throw "prepare failed" }

if ($TestApi -or ((-not $ApiId) -and (-not $ApiHash))) {
    $apiArgs = "-D TDESKTOP_API_TEST=ON"
} elseif ($ApiId -and $ApiHash) {
    $apiArgs = "-D TDESKTOP_API_ID=$ApiId -D TDESKTOP_API_HASH=$ApiHash"
} else {
    throw "Provide both -ApiId and -ApiHash, or use -TestApi."
}

$cmd = "call `"$vcvars`" -vcvars_ver=14.44 >nul && cd /d `"$tdesktop\Telegram`" && configure.bat x64 $apiArgs"
& cmd.exe /c $cmd
if ($LASTEXITCODE -ne 0) { throw "configure failed" }

$cmd = "call `"$vcvars`" -vcvars_ver=14.44 >nul && cd /d `"$tdesktop`" && msbuild out\Telegram.slnx /t:Telegram /p:Configuration=Release /p:Platform=x64 /m"
& cmd.exe /c $cmd
if ($LASTEXITCODE -ne 0) { throw "build failed" }

Write-Host "Built: $tdesktop\out\Release\Telegram.exe"
