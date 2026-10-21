# Проверка одной кнопкой: собирает два набора тестовых пакетов через BRPC.exe --merge
# и сверяет результат с ожидаемым. Всё создаётся во временной папке Windows, проект не трогается.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

$exe = Join-Path (Split-Path $PSScriptRoot -Parent) 'BRPC.exe'
$root = Join-Path ([IO.Path]::GetTempPath()) 'BRPC-check'
$failed = New-Object System.Collections.Generic.List[string]

function Fail($text) { $failed.Add($text); Write-Host ('  ОШИБКА: ' + $text) -ForegroundColor Red }
function Ok($text) { Write-Host ('  ok: ' + $text) -ForegroundColor DarkGray }

if (-not (Test-Path $exe)) {
    Write-Host 'Не найден BRPC.exe рядом с папкой tools. Сначала соберите программу: build.bat' -ForegroundColor Red
    exit 2
}

$enc = New-Object System.Text.UTF8Encoding $false
function W($path, $text) { New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null; [IO.File]::WriteAllText($path, $text, $enc) }
function MkPng($path, $color) {
    New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
    $b = New-Object System.Drawing.Bitmap 16, 16
    $g = [System.Drawing.Graphics]::FromImage($b); $g.Clear($color); $g.Dispose()
    $b.Save($path); $b.Dispose()
}
function MkMan($n, $extra) {
    '{"format_version":2,"header":{"name":"' + $n + '","uuid":"' + [guid]::NewGuid() + '","version":[1,0,0],"min_engine_version":[1,20,0]},"modules":[{"type":"resources","uuid":"' + [guid]::NewGuid() + '","version":[1,0,0]}]' + $extra + '}'
}

# Сборка без окна; настройки пользователя не читаются, язык журнала — русский.
function Merge($dir, $packs) {
    $env:BPS_DEFAULTS = '1'
    $env:BPS_LANG = 'ru'
    $argList = @('--merge', ('"' + (Join-Path $dir 'out.mcpack') + '"'), '"Merged"')
    foreach ($p in $packs) { $argList += ('"' + (Join-Path $dir $p) + '"') }
    $proc = Start-Process -FilePath $exe -ArgumentList $argList -Wait -PassThru
    $log = Join-Path $dir 'out.mcpack.log'
    $text = if (Test-Path $log) { [IO.File]::ReadAllText($log, [Text.Encoding]::UTF8) } else { '' }
    return @{ Code = $proc.ExitCode; Log = $text; Zip = (Join-Path $dir 'out.mcpack') }
}

function ReadEntry($zipPath, $name) {
    $z = [IO.Compression.ZipFile]::OpenRead($zipPath)
    try {
        foreach ($e in $z.Entries) {
            if ($e.FullName -eq $name) { $r = New-Object IO.StreamReader($e.Open()); try { return $r.ReadToEnd() } finally { $r.Close() } }
        }
        return $null
    } finally { $z.Dispose() }
}

if (Test-Path $root) { Remove-Item -Recurse -Force -LiteralPath $root }
New-Item -ItemType Directory -Force $root | Out-Null

# ---- набор 1: слияние UI, сущностей, анимаций, моделей, вариант пакета
Write-Host 'Набор 1: слияние JSON, сущностей и моделей'
$t = Join-Path $root 'set1'
W "$t\A\manifest.json" (MkMan 'A' ',"capabilities":["pbr"]')
W "$t\A\ui\hud_screen.json" '{"namespace":"hud","hotbar@common.panel":{"size":[1,1]},"a_elem":{"type":"label"}}'
W "$t\A\entity\zombie.entity.json" '{"format_version":"1.10.0","minecraft:client_entity":{"description":{"identifier":"minecraft:zombie","textures":{"default":"textures/entity/zombie_a"},"scripts":{"animate":["walk"]},"render_controllers":["controller.render.a"]}}}'
W "$t\A\animations\a.animation.json" '{"format_version":"1.8.0","animations":{"animation.zombie.walk":{"loop":true,"bones":{"a":{}}}}}'
MkPng "$t\A\textures\blocks\stone.png" ([System.Drawing.Color]::Red)
W "$t\B\manifest.json" (MkMan 'B' ',"subpacks":[{"folder_name":"hd","name":"HD","memory_tier":1}]')
W "$t\B\ui\hud_screen.json" '{"namespace":"hud","hotbar":{"size":[9,9]},"b_elem":{"type":"image"}}'
W "$t\B\entity\zombie_custom.json" '{"format_version":"1.10.0","minecraft:client_entity":{"description":{"identifier":"minecraft:zombie","textures":{"default":"textures/entity/zombie_b","glow":"textures/entity/zombie_glow"},"scripts":{"animate":["blink"]},"render_controllers":["controller.render.b"]}}}'
W "$t\B\animations\b.animation.json" '{"format_version":"1.8.0","animations":{"animation.zombie.walk":{"loop":false,"bones":{"b":{}}},"animation.zombie.blink":{"loop":true}}}'
W "$t\B\models\entity\zombie.geo.json" '{"format_version":"1.12.0","minecraft:geometry":[{"description":{"identifier":"geometry.zombie"},"bones":[{"name":"B"}]}]}'
New-Item -ItemType Directory -Force "$t\B\textures\blocks" | Out-Null
[IO.File]::WriteAllBytes("$t\B\textures\blocks\stone.tga", (New-Object byte[] 18))
MkPng "$t\B\textures\blocks\dirt.png" ([System.Drawing.Color]::Blue)
MkPng "$t\B\subpacks\hd\textures\blocks\dirt.png" ([System.Drawing.Color]::Blue)
W "$t\C\manifest.json" (MkMan 'C' ',"capabilities":["pbr","raytraced"]')
W "$t\C\ui\hud_screen.json" '{"namespace":"hud","c_elem":{"type":"panel"},"b_elem":{"type":"C_LOSES"}}'
W "$t\C\models\entity\mobs.geo.json" '{"format_version":"1.12.0","minecraft:geometry":[{"description":{"identifier":"geometry.zombie"},"bones":[{"name":"C_LOSES"}]},{"description":{"identifier":"geometry.cow"},"bones":[]}]}'
W "$t\C\entity\cow.entity.json" '{"format_version":"1.10.0","minecraft:client_entity":{"description":{"identifier":"minecraft:cow"}}}'
MkPng "$t\C\textures\items\apple.png" ([System.Drawing.Color]::Green)

$r = Merge $t @('A', 'B', 'C')
if ($r.Code -ne 0) { Fail ('сборка завершилась с кодом ' + $r.Code) } else { Ok 'сборка без ошибок' }
if ($r.Log -match 'Файлов в сборке: 11\.') { Ok 'в сборке 11 файлов' } else { Fail 'в журнале нет «Файлов в сборке: 11.»' }
if (Test-Path $r.Zip) {
    $hud = ReadEntry $r.Zip 'ui/hud_screen.json'
    if ($hud -and $hud -match 'a_elem' -and $hud -match 'b_elem' -and $hud -match 'c_elem' -and $hud -notmatch 'C_LOSES') { Ok 'UI из трёх пакетов слит, верхний пакет главнее' } else { Fail 'ui/hud_screen.json слит неправильно' }
} else { Fail 'файл сборки не создан' }

# ---- набор 2: PBR-слои и шейдерный пакет
Write-Host 'Набор 2: слои PBR'
$t = Join-Path $root 'set2'
$B = 'textures\blocks'
function MkMan2($n) { '{"format_version":2,"header":{"name":"' + $n + '","uuid":"' + [guid]::NewGuid() + '","version":[1,0,0],"min_engine_version":[1,21,0]},"modules":[{"type":"resources","uuid":"' + [guid]::NewGuid() + '","version":[1,0,0]}],"capabilities":["pbr"]}' }
W "$t\T\manifest.json" (MkMan2 'T'); MkPng "$t\T\$B\dirt.png" ([System.Drawing.Color]::Brown)
W "$t\P\manifest.json" (MkMan2 'P'); MkPng "$t\P\$B\stone.png" ([System.Drawing.Color]::Gray); MkPng "$t\P\$B\stone_h.png" ([System.Drawing.Color]::White)
W "$t\P\$B\stone.texture_set.json" '{"format_version":"1.16.100","minecraft:texture_set":{"color":"stone","heightmap":"stone_h"}}'
W "$t\P\textures\terrain_texture.json" '{"texture_data":{"stone":{"textures":{"path":"textures/blocks/stone"}}}}'
W "$t\S\manifest.json" (MkMan2 'S')
foreach ($n in 'stone', 'dirt', 'sand') {
    MkPng "$t\S\$B\$n.png" ([System.Drawing.Color]::Blue); MkPng "$t\S\$B\${n}_mer.png" ([System.Drawing.Color]::Red); MkPng "$t\S\$B\${n}_normal.png" ([System.Drawing.Color]::Purple)
    W "$t\S\$B\$n.texture_set.json" ('{"format_version":"1.16.100","minecraft:texture_set":{"color":"' + $n + '","metalness_emissive_roughness":"' + $n + '_mer","normal":"' + $n + '_normal"}}')
}
W "$t\S\textures\terrain_texture.json" '{"texture_data":{"stone":{"textures":{"path":"textures/blocks/stone","overlay_color":"#ff0000"}},"sand":{"textures":"textures/blocks/sand"}}}'

$r = Merge $t @('T', 'P', 'S')
if ($r.Code -ne 0) { Fail ('сборка завершилась с кодом ' + $r.Code) } else { Ok 'сборка без ошибок' }
if ($r.Log -match 'Файлов в сборке: 10\.') { Ok 'в сборке 10 файлов' } else { Fail 'в журнале нет «Файлов в сборке: 10.»' }

# ---- набор 3: временная папка — очистка убирает только своё
Write-Host 'Набор 3: очистка временной папки не трогает чужие файлы'
$t = Join-Path $root 'set3'
$app = Join-Path $t 'app'
$tmp = Join-Path $t 'tmp'
New-Item -ItemType Directory -Force $app, $tmp | Out-Null
Copy-Item $exe (Join-Path $app 'BRPC.exe')
# чужое: файл и папка в BRPC-temp, старая папка temp
W "$app\BRPC-temp\чужой файл.txt" 'не удалять'
W "$app\BRPC-temp\чужая папка\внутри.txt" 'не удалять'
W "$app\temp\не удалять.txt" 'не удалять'
# пакет архивом: при сборке он распаковывается в BRPC-temp и после неё убирается
W "$t\Z\manifest.json" (MkMan 'Z' '')
MkPng "$t\Z\textures\blocks\stone.png" ([System.Drawing.Color]::Red)
[IO.Compression.ZipFile]::CreateFromDirectory("$t\Z", "$t\Z.mcpack")
$env:BPS_DEFAULTS = '1'; $env:BPS_LANG = 'ru'
$proc = Start-Process -FilePath (Join-Path $app 'BRPC.exe') -ArgumentList @('--merge', ('"' + "$t\out.mcpack" + '"'), '"Merged"', ('"' + "$t\Z.mcpack" + '"')) -Wait -PassThru
if ($proc.ExitCode -eq 0) { Ok 'архив собран' } else { Fail ('сборка архива завершилась с кодом ' + $proc.ExitCode) }
$left = @(Get-ChildItem -LiteralPath "$app\BRPC-temp" -Force | Where-Object { $_.Name -ne 'чужой файл.txt' -and $_.Name -ne 'чужая папка' })
if ($left.Count -eq 0) { Ok 'распакованное после сборки убрано' } else { Fail ('после сборки в BRPC-temp осталось: ' + (($left | ForEach-Object { $_.Name }) -join ', ')) }
# полная очистка (как при закрытии программы): своя помеченная папка удаляется, чужое остаётся.
# Отдельный процесс с временной папкой Windows внутри проверки, чтобы не задеть открытое окно программы.
New-Item -ItemType Directory -Force "$app\BRPC-temp\наша распаковка" | Out-Null
W "$app\BRPC-temp\наша распаковка\a.txt" 'x'
W "$app\BRPC-temp\наша распаковка.brpc-temp" 'BRPC'
$probe = @'
param($exe)
$asm = [Reflection.Assembly]::LoadFile($exe)
$pl = $asm.GetType('BedrockPackStudio.PackLoader')
$f = [Reflection.BindingFlags]'Static,Public,NonPublic'
$pl.GetMethod('ClearTemp', $f).Invoke($null, @()) | Out-Null
'cleared ' + $pl.GetField('TempBase', $f).GetValue($null)
'@
$probeFile = Join-Path $t 'probe.ps1'
[IO.File]::WriteAllText($probeFile, $probe, (New-Object System.Text.UTF8Encoding $true))
$oldTmp = $env:TMP; $oldTemp = $env:TEMP
$env:TMP = $tmp; $env:TEMP = $tmp
try { $said = & powershell -NoProfile -ExecutionPolicy Bypass -File $probeFile (Join-Path $app 'BRPC.exe') }
finally { $env:TMP = $oldTmp; $env:TEMP = $oldTemp }
if ("$said" -like 'cleared*BRPC-temp') { Ok 'очистка запущена в BRPC-temp' } else { Fail ('очистка не запустилась: ' + $said) }
if (-not (Test-Path -LiteralPath "$app\BRPC-temp\наша распаковка")) { Ok 'своя распаковка удалена' } else { Fail 'своя распаковка не удалена' }
if ((Test-Path -LiteralPath "$app\BRPC-temp\чужой файл.txt") -and (Test-Path -LiteralPath "$app\BRPC-temp\чужая папка\внутри.txt") -and (Test-Path -LiteralPath "$app\temp\не удалять.txt")) { Ok 'чужие файлы и папки на месте' } else { Fail 'очистка удалила чужие файлы' }

Write-Host ''
if ($failed.Count -eq 0) {
    Write-Host '=== ПРОВЕРКА ПРОЙДЕНА ===' -ForegroundColor Green
    exit 0
}
Write-Host ('=== ПРОВЕРКА НЕ ПРОЙДЕНА: ошибок ' + $failed.Count + ' ===') -ForegroundColor Red
Write-Host ('Журналы сборки: ' + $root)
exit 1
