# Сборка Telegram Desktop 7.4.4 на Windows

Проверено на Windows 10 22H2 (19045), Visual Studio 2026 18.12.1, Windows SDK 10.0.28000.0, Git 2.56.1, Python 3.14.7.

## 1. Что установить

- **Visual Studio 2026** с workload **Desktop development with C++**.
- **Windows SDK** (в этой сборке использовался 10.0.28000.0).
- **Git** 2.56+.
- **Python** 3.10+ (в этой сборке — 3.14.7).
- Свободное место: не менее 45 ГБ на диске сборки.

Точный набор версий из лога:

| Компонент | Версия |
|---|---|
| Visual Studio | 18.12.1 |
| MSVC toolset | 14.52.37025 (`v145`) |
| Windows SDK | 10.0.28000.0 |
| Qt | 6.11.2 |
| Python | 3.14.7 |
| Git | 2.56.1 |

## 2. Клонирование upstream

```powershell
mkdir H:\ModTG
cd H:\ModTG
git clone --recursive --branch v7.4.4 https://github.com/telegramdesktop/tdesktop.git
```

Upstream-тег: `v7.4.4`, коммит `bf4f714036f21c750d535dab199c811b3f9bfdd4`.

## 3. Применение патчей

Скопируйте этот репозиторий, например, в `H:\ModTG\telegrammoderatorpack`, затем:

```powershell
$PACK = "H:\ModTG\telegrammoderatorpack"

git -C H:\ModTG\tdesktop apply "$PACK\patches\prepare.py.diff"
git -C H:\ModTG\tdesktop\cmake apply "$PACK\patches\run_cmake.py.diff"
git -C H:\ModTG\tdesktop\Telegram\lib_ui apply "$PACK\patches\lib_ui-windows-theme.diff"
git -C H:\ModTG\tdesktop apply "$PACK\patches\windows-visual-theme.diff"
```

Патчи делают следующее:

- `prepare.py.diff`:
  - переключает MSYS2 на доступное зеркало Tsinghua;
  - скачивает `nuget.exe` из пакета `NuGet.CommandLine` через `api.nuget.org`;
  - скачивает `jom` с зеркала Tencent;
  - использует toolset `v145` для lzma и dump_syms;
  - собирает libvpx с target `x86_64-win64-vs17-v145`;
  - делает shallow clone FFmpeg и исправляет определение MSVC в его `configure`.
- `run_cmake.py.diff`: заменяет `-T v143` на `-T v145`, потому что в VS 2026 компонент v143 отсутствует.
- `lib_ui-windows-theme.diff`: меняет палитру `ui/colors.palette` на нейтральную Windows-палитру и включает глобальный масштаб иконок 1.1.
- `windows-visual-theme.diff`: уменьшает строки списка чатов до 60 px, обновляет отступы и перекрашивает `night.tdesktop-theme` в нейтральную тёмную тему.

## 4. Подготовка зависимостей

Запускать из терминала **x64 Native Tools Command Prompt for VS 2026** или после `vcvars64.bat -vcvars_ver=14.44`.

Сначала клонируется репозиторий `desktop-app/patches`:

```powershell
cd H:\ModTG
tdesktop\Telegram\build\prepare\win.bat patches
```

Затем применяется правка FFmpeg-скрипта:

```powershell
git -C H:\ModTG\Libraries\win64\patches apply "$PACK\patches\build_ffmpeg_win.sh.diff"
```

И запускается полная подготовка:

```powershell
tdesktop\Telegram\build\prepare\win.bat silent
```

Это самый долгий этап: скачиваются и собираются Qt, FFmpeg, OpenSSL, libvpx, libjxl, libheif, tg_owc, Rust-зависимости и остальные библиотеки.

## 5. Конфигурация

Для тестовой сборки:

```powershell
cd H:\ModTG\tdesktop\Telegram
configure.bat x64 -D TDESKTOP_API_TEST=ON
```

Для реального клиента:

```powershell
configure.bat x64 -D TDESKTOP_API_ID=ВАШ_API_ID -D TDESKTOP_API_HASH=ВАШ_API_HASH
```

`configure.bat` создаёт `H:\ModTG\tdesktop\out\Telegram.slnx`.

## 6. Сборка

```powershell
cd H:\ModTG\tdesktop
msbuild out\Telegram.slnx /t:Telegram /p:Configuration=Release /p:Platform=x64 /m
```

Результат:

```text
H:\ModTG\tdesktop\out\Release\Telegram.exe
```

Рядом должна оставаться папка `modules` — в неё post-build копирует `d3dcompiler_47.dll` для ANGLE.

## 7. Визуальные изменения

| Файл | Изменение |
|---|---|
| `lib_ui/ui/colors.palette` | Светлая палитра: фон `#FFFFFF`, текст `#1F1F1F`, вторичный текст `#6B6B6B`, акцент `#0078D7`, активный текст `#0067B8` |
| `lib_ui/ui/style/style_core_icon.cpp` | Глобальный коэффициент иконок `1.1`, то есть +10% по ширине и высоте |
| `dialogs/dialogs.style` | Компактная строка чата: высота `60 px`, аватар `44 px`, отступы `7 px` |
| `Resources/night.tdesktop-theme` | Тёмная палитра: фон `#1F1F1F`, поверхности `#2B2B2B`, акцент `#0F6CBD`, активный текст `#4CC2FF` |

Проверка после применения: сборка Release x64 завершилась с 0 ошибок и 0 предупреждений; `Telegram.exe` запускается с временным профилем.

## 8. Известные особенности

- VS 2026 не содержит toolset `v143`, поэтому все MSBuild-проекты, которые его требуют, переводятся на `v145`. Это относится к lzma, dump_syms, libvpx и `run_cmake.py`.
- FFmpeg определяет MSVC по первой строке вывода `cl.exe`. При русской локализации строка начинается не с `Microsoft`, поэтому в `configure` заменяется проверка `grep -q ^Microsoft` на `grep -qi Microsoft`.
- `dist.nuget.org` и `master.qt.io` в этой сети были недоступны; используются `api.nuget.org` и зеркало Tencent.
- `mirror.msys2.org` не отвечал; MSYS2 переключён на Tsinghua.
- Тестовая сборка с `TDESKTOP_API_TEST=ON` использует официальные TEST ONLY credentials и не подходит для реального использования.
- Собранный exe не подписан. SmartScreen может показывать предупреждение.
- Квадратные аватары и полная переработка геометрии пузырей сообщений в этот проход не входят.
