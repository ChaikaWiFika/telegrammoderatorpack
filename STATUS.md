# Статус сборки

**Дата:** 24.11.2026  
**Ветка/тег:** `v7.4.4`  
**Конфигурация:** Release, x64  
**Результат:** успешно

## Артефакты

| Параметр | Значение |
|---|---|
| Исполняемый файл | `H:\ModTG\tdesktop\out\Release\Telegram.exe` |
| Размер | 271 563 776 байт (~259 МБ) |
| SHA-256 | `525EFE8A21F5F203D228C94320208F3F250B9BEFF1C24C51B3983CDB188DDDD5` |
| Версия файла | 7.4.4.0 |
| PDB | `out\Release\Telegram.pdb`, 4 417 773 568 байт (не в Git) |
| Время финальной сборки | 4 мин 41 с |
| Ошибки | 0 |
| Предупреждения | 0 |

## Визуальные изменения

- `Telegram/lib_ui/ui/colors.palette`: нейтральная светлая палитра, акцент `#0078D7`, активный текст `#0067B8`.
- `Telegram/SourceFiles/dialogs/dialogs.style`: компактные строки чата, высота 60 px, аватар 44 px, обновлённые отступы.
- `Telegram/lib_ui/ui/style/style_core_icon.cpp`: глобальный масштаб иконок 1.1 (`20 px -> 22 px`).
- `Telegram/Resources/night.tdesktop-theme`: нейтральная тёмная палитра, акцент `#0F6CBD`, текст `#4CC2FF`.

## API credentials

Сборка выполнена с `TDESKTOP_API_TEST=ON`, то есть с официальными **TEST ONLY** credentials из upstream-репозитория:

- `api_id`: 17349
- `api_hash`: `344583e45741c457fe1862106095a5eb`

Это **не** credentials для постоянного использования. Для реального клиента нужно получить свой `api_id`/`api_hash` на my.telegram.org и пересобрать проект:

```powershell
cd H:\ModTG\tdesktop\Telegram
configure.bat x64 -D TDESKTOP_API_ID=... -D TDESKTOP_API_HASH=...
cd H:\ModTG\tdesktop
msbuild out\Telegram.slnx /t:Telegram /p:Configuration=Release /p:Platform=x64 /m
```

## Что не хранится в репозитории

- `H:\ModTG\Libraries` - собранные зависимости.
- `H:\ModTG\ThirdParty` - MSYS2, Rust, Python venv, NuGet, jom.
- `H:\ModTG\tdesktop\out` - объектные файлы, PDB и exe.
- `Telegram.pdb` - 4,4 ГБ, нужен только для отладки.
- `tdata`, логи и любые `api_hash`/токены.

Эти данные воспроизводятся командами из `BUILD.md`; бинарник при необходимости публикуется отдельно через GitHub Releases.
