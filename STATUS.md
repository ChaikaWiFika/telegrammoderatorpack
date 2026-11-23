# Статус сборки

**Дата:** 24.11.2026  
**Ветка/тег:** `v7.4.4`  
**Конфигурация:** Release, x64  
**Результат:** успешно

## Артефакты

| Параметр | Значение |
|---|---|
| Исполняемый файл | `H:\ModTG\tdesktop\out\Release\Telegram.exe` |
| Размер | 271 562 752 байт (~259 МБ) |
| SHA-256 | `F7E25AC22E22502403E6F32E9419A0FF0979CE334D77A7EFA4B17E9955B48BA2` |
| Версия файла | 7.4.4.0 |
| PDB | `out\Release\Telegram.pdb`, 4 146 290 688 байт (не в Git) |
| Время финальной сборки | 17 мин 17 с |
| Ошибки | 0 |
| Предупреждения | 1 — `C4864` в `api_confirm_phone.cpp`, на работу не влияет |

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

- `H:\ModTG\Libraries` — 42,7 ГБ собранных зависимостей.
- `H:\ModTG\ThirdParty` — 1,2 ГБ MSYS2, Rust, Python venv, NuGet, jom.
- `H:\ModTG\tdesktop\out` — 43 ГБ объектных файлов, PDB и exe.
- `Telegram.pdb` — 4,1 ГБ, нужен только для отладки.
- `tdata`, логи и любые `api_hash`/токены.

Эти данные воспроизводятся командами из `BUILD.md`; бинарник при необходимости публикуется отдельно через GitHub Releases.
