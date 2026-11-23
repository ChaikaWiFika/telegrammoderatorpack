# Патчи

| Файл | Куда применять |
|---|---|
| `prepare.py.diff` | `tdesktop/Telegram/build/prepare/prepare.py` |
| `run_cmake.py.diff` | `tdesktop/cmake/run_cmake.py` (git submodule `cmake`) |
| `build_ffmpeg_win.sh.diff` | `Libraries/win64/patches/build_ffmpeg_win.sh` после `prepare\win.bat patches` |

Пример:

```powershell
$PACK = "H:\ModTG\telegrammoderatorpack"

git -C H:\ModTG\tdesktop apply "$PACK\patches\prepare.py.diff"
git -C H:\ModTG\tdesktop\cmake apply "$PACK\patches\run_cmake.py.diff"
git -C H:\ModTG\Libraries\win64\patches apply "$PACK\patches\build_ffmpeg_win.sh.diff"
```

Порядок важен: `build_ffmpeg_win.sh` появляется только после того, как `prepare\win.bat patches` склонирует репозиторий `desktop-app/patches`.
