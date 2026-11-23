# Бинарник

Готовый тестовый бинарник:

- `H:\ModTG\tdesktop\out\Release\Telegram.exe`
- Размер: 271 563 776 байт (~259 МБ)
- SHA-256: `525EFE8A21F5F203D228C94320208F3F250B9BEFF1C24C51B3983CDB188DDDD5`
- Версия: 7.4.4
- API: TEST ONLY (`TDESKTOP_API_TEST=ON`)
- Сборка: Release x64, 0 ошибок, 0 предупреждений, 4 мин 41 с

Бинарник не коммитится в Git: GitHub не принимает файлы такого размера в обычный репозиторий, а PDB весит 4,4 ГБ. Для публикации используйте GitHub Releases и прикрепите `Telegram.exe` как asset. Папку `modules` из `out\Release` нужно сохранить рядом с exe.

Для реального клиента пересоберите проект со своими `api_id` и `api_hash` по инструкции в `BUILD.md`.
