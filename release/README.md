# Бинарник

Готовый тестовый бинарник:

- `H:\ModTG\tdesktop\out\Release\Telegram.exe`
- Размер: 271 562 752 байт (~259 МБ)
- SHA-256: `F7E25AC22E22502403E6F32E9419A0FF0979CE334D77A7EFA4B17E9955B48BA2`
- Версия: 7.4.4
- API: TEST ONLY (`TDESKTOP_API_TEST=ON`)

Бинарник не коммитится в Git: GitHub не принимает файлы такого размера в обычный репозиторий, а PDB весит 4,1 ГБ. Для публикации используйте GitHub Releases и прикрепите `Telegram.exe` как asset. Папку `modules` из `out\Release` нужно сохранить рядом с exe.

Для реального клиента пересоберите проект со своими `api_id` и `api_hash` по инструкции в `BUILD.md`.
