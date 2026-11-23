# Telegram Moderator Pack

Компактный набор для воспроизведения сборки **Telegram Desktop 7.4.4** под Windows x64. В репозитории лежат патчи, скрипты, документация и утверждённый дизайн-прототип; полное дерево сборки (87 ГБ) и бинарник (259 МБ) в Git не включены.

## Статус

- Сборка: **успешно**, Release x64, 0 ошибок, 1 предупреждение.
- Версия: **7.4.4**.
- Бинарник: `tdesktop\out\Release\Telegram.exe`, 271 562 752 байт.
- SHA-256: `F7E25AC22E22502403E6F32E9419A0FF0979CE334D77A7EFA4B17E9955B48BA2`.
- Использованы **TEST ONLY** credentials; для реального входа нужны свои `api_id` и `api_hash`.

Подробности в [STATUS.md](STATUS.md).

## Что внутри

| Путь | Назначение |
|---|---|
| `patches/` | Диффы к upstream Telegram Desktop v7.4.4 и его build-хелперам |
| `scripts/build.ps1` | Скрипт сборки: clone, патчи, prepare, configure, msbuild |
| `BUILD.md` | Пошаговая инструкция |
| `STATUS.md` | Текущий результат сборки и ограничения |
| `SOURCE.md` | Upstream-репозиторий, тег и коммит |
| `release/README.md` | Параметры бинарника и как его опубликовать |
| `design/` | Утверждённый V3 прототип интерфейса и его описание |

## Дизайн интерфейса

Утверждённый V3 прототип: [design/telegram-desktop-windows-ui.html](design/telegram-desktop-windows-ui.html).

- Официальная компоновка Telegram Desktop сохранена: меню и поиск слева, закреплённые и обычные чаты строками, действия чата в шапке диалога, вложение, поле, эмодзи и отправка в composer.
- Визуальный язык: Windows Store / Metro, Segoe UI, квадратная геометрия, плоские поверхности, синий акцент.
- По умолчанию включена компактная плотность.
- Иконки увеличены на 10% по ширине и высоте.
- Есть светлая и тёмная темы, настройки, контакты, звонки, поиск и демо-состояния.

Подробности в [design/README.md](design/README.md).

## Быстрый старт

1. Установите Visual Studio 2026 с workload **Desktop development with C++** и Windows SDK, Git и Python 3.10+ (проверено на 3.14).
2. Клонируйте upstream:

```powershell
git clone --recursive --branch v7.4.4 https://github.com/telegramdesktop/tdesktop.git H:\ModTG\tdesktop
```

3. Примените патчи из этого репозитория:

```powershell
$PACK = "H:\ModTG\telegrammoderatorpack"
git -C H:\ModTG\tdesktop apply "$PACK\patches\prepare.py.diff"
git -C H:\ModTG\tdesktop\cmake apply "$PACK\patches\run_cmake.py.diff"
```

4. Подготовьте зависимости:

```powershell
cd H:\ModTG
tdesktop\Telegram\build\prepare\win.bat patches
git -C Libraries\win64\patches apply "$PACK\patches\build_ffmpeg_win.sh.diff"
tdesktop\Telegram\build\prepare\win.bat silent
```

5. Сконфигурируйте и соберите:

```powershell
cd H:\ModTG\tdesktop\Telegram
configure.bat x64 -D TDESKTOP_API_TEST=ON
cd H:\ModTG\tdesktop
msbuild out\Telegram.slnx /t:Telegram /p:Configuration=Release /p:Platform=x64 /m
```

Готовый файл: `H:\ModTG\tdesktop\out\Release\Telegram.exe`.

Для реального клиента вместо `-D TDESKTOP_API_TEST=ON` используйте:

```powershell
configure.bat x64 -D TDESKTOP_API_ID=ВАШ_API_ID -D TDESKTOP_API_HASH=ВАШ_API_HASH
```

## Важно

- **TEST ONLY** credentials ограничены сервером Telegram. Это только проверка сборки, не для постоянного использования.
- Собранный `Telegram.exe` не подписан; Windows SmartScreen может предупреждать.
- Не коммитьте `api_hash`, `tdata`, логи и файлы сессий.
- Полное дерево `Libraries`, `ThirdParty` и `tdesktop\out` не хранится в Git: его нужно собрать локально.
- Дизайн-прототип пока не перенесён в C++/Qt. Это отдельный этап, в котором меняется только визуальный слой, а расположение кнопок остаётся официальным.
