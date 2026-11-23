# Патчи

## Сборка

| Файл | Куда применять |
|---|---|
| `prepare.py.diff` | `tdesktop/Telegram/build/prepare/prepare.py` |
| `run_cmake.py.diff` | `tdesktop/cmake/run_cmake.py` (git submodule `cmake`) |
| `build_ffmpeg_win.sh.diff` | `Libraries/win64/patches/build_ffmpeg_win.sh` после `prepare\win.bat patches` |

```powershell
$PACK = "H:\ModTG\telegrammoderatorpack"

git -C H:\ModTG\tdesktop apply "$PACK\patches\prepare.py.diff"
git -C H:\ModTG\tdesktop\cmake apply "$PACK\patches\run_cmake.py.diff"
git -C H:\ModTG\Libraries\win64\patches apply "$PACK\patches\build_ffmpeg_win.sh.diff"
```

## Визуальная тема

| Файл | Куда применять |
|---|---|
| `lib_ui-windows-theme.diff` | `tdesktop/Telegram/lib_ui` (`ui/colors.palette`, `ui/style/style_core_icon.cpp`) |
| `windows-visual-theme.diff` | `tdesktop` (`Telegram/SourceFiles/dialogs/dialogs.style`, `Telegram/Resources/night.tdesktop-theme`) |

```powershell
git -C H:\ModTG\tdesktop\Telegram\lib_ui apply "$PACK\patches\lib_ui-windows-theme.diff"
git -C H:\ModTG\tdesktop apply "$PACK\patches\windows-visual-theme.diff"
```

`windows-visual-theme.diff` содержит бинарный патч для `night.tdesktop-theme`, поэтому применяйте его через `git apply`, а не вручную.
