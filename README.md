# Telegram Moderator Pack

Компактный набор для воспроизведения сборки **Telegram Desktop 7.4.4** под Windows x64. В репозитории лежат патчи, скрипты, документация и утверждённый дизайн-прототип; полное дерево сборки (87 ГБ) и бинарник (259 МБ) в Git не включены.

## Статус

- Сборка: **успешно**, Release x64, 0 ошибок, 0 предупреждений.
- Версия: **7.4.4**.
- Бинарник: `tdesktop\out\Release\Telegram.exe`, 271 563 776 байт.
- SHA-256: `525EFE8A21F5F203D228C94320208F3F250B9BEFF1C24C51B3983CDB188DDDD5`.
- Использованы **TEST ONLY** credentials; для реального входа нужны свои `api_id` и `api_hash`.

Подробности в [STATUS.md](STATUS.md).

## Что внутри

| Путь | Назначение |
|---|---|
| `patches/` | Патчи сборки и визуальной темы |
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

Визуальные изменения уже внесены в C++/Qt-код и собираются:

| Патч | Что меняет |
|---|---|
| `patches/lib_ui-windows-theme.diff` | Палитра `ui/colors.palette` и глобальный масштаб иконок `kIconScale = 1.1` |
| `patches/windows-visual-theme.diff` | Компактные строки чата и тёмная тема `night.tdesktop-theme` |

Подробности в [design/README.md](design/README.md) и [BUILD.md](BUILD.md).

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
git -C H:\ModTG\tdesktop\Telegram\lib_ui apply "$PACK\patches\lib_ui-windows-theme.diff"
git -C H:\ModTG\tdesktop apply "$PACK\patches\windows-visual-theme.diff"
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
- Визуальные изменения пока не включают квадратные аватары и полную переработку геометрии пузырей сообщений. Это следующий этап.
