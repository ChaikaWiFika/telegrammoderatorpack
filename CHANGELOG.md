# Изменения

## 2026-11-24 - V3 Windows UI design prototype

Добавлен утверждённый прототип интерфейса `design/telegram-desktop-windows-ui.html`.

- Официальная компоновка Telegram Desktop сохранена: меню и поиск слева, действия чата в шапке диалога, composer с вложением, полем, эмодзи и отправкой.
- Визуальный язык Windows Store: Segoe UI, квадратная геометрия, плоские поверхности, синий акцент.
- Компактная плотность включена по умолчанию.
- Иконки увеличены на 10% по ширине и высоте.
- Добавлены светлая и тёмная темы, настройки, контакты, звонки, поиск, toast, splash и демо-состояния.
- Прототип не подключён к Telegram API и не перенесён в C++/Qt.

## 2026-11-24 - первая успешная сборка v7.4.4

Собрано: `Telegram.exe` 7.4.4, Release x64, 271 562 752 байт, SHA-256 `F7E25AC22E22502403E6F32E9419A0FF0979CE334D77A7EFA4B17E9955B48BA2`.

Патчи:

- `prepare.py.diff`
  - MSYS2: зеркало заменено на Tsinghua, добавлен `--disable-download-timeout`.
  - NuGet: `nuget.exe` скачивается из пакета `NuGet.CommandLine` через `api.nuget.org`.
  - jom: скачивается с зеркала Tencent.
  - lzma: `PlatformToolset=v145`.
  - libvpx: target `x86_64-win64-vs17-v145`.
  - FFmpeg: shallow clone и исправление определения MSVC для русской локализации `cl.exe`.
  - dump_syms: `PlatformToolset=v145`.
- `run_cmake.py.diff`: `-T v145` вместо `-T v143`.
- `build_ffmpeg_win.sh.diff`: `export VSLANG=1033`.

Причина правок: в VS 2026 отсутствует toolset v143, а `dist.nuget.org`, `master.qt.io` и `mirror.msys2.org` были недоступны из этой сети.
