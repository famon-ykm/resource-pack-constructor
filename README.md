# Resource Pack Constructor: for Minecraft Bedrock (Beta)

> **NOT AN OFFICIAL MINECRAFT PRODUCT. NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.**

### ⬇ [Download the program (ResourcePackConstructor.zip)](https://github.com/famon-ykm/resource-pack-constructor/releases/latest/download/ResourcePackConstructor.zip)
### ⬇ [Скачать программу (ResourcePackConstructor.zip)](https://github.com/famon-ykm/resource-pack-constructor/releases/latest/download/ResourcePackConstructor.zip)

Unpack the archive and run `ResourcePackConstructor.exe`. / Распакуйте архив и запустите `ResourcePackConstructor.exe`.

A Windows program for browsing Minecraft Bedrock resource packs side by side and merging them into one `.mcpack`.

Программа для Windows: показывает пакеты текстур Minecraft Bedrock рядом и собирает из них один `.mcpack`. [Описание на русском](#по-русски) ниже.

![Main window](docs/screenshot.png)

The program is in beta: it works, but not every part has been tested thoroughly. Bug reports are welcome in [Issues](../../issues).

## Features

- Load packs from folders, `.mcpack`, `.zip` and `.mcaddon` (also Java Edition packs, converted on load); drag to reorder — the top pack has priority.
- Textures are sorted into types and categories; every texture shows the variants from all loaded packs, click to choose one or switch it off.
- Smart merge instead of plain overwrite: `terrain_texture.json`, `item_texture.json`, `blocks.json`, flipbooks, UI files, entities, geometry and `.lang` files are combined by content.
- PBR layers (reflections, emission, relief): pick each layer from any pack, texture sets are rebuilt to stay valid.
- Subpack (variant) selection per pack, random texture variants for blocks and mobs.
- 2D list and 3D view of blocks and mobs assembled from the textures (the 3D models of mobs need Minecraft for Windows installed).
- Built-in texture editor: tools, selection, shapes, clipboard, colour adjustments, mirror and seamless drawing, animation frames, live 3D preview.
- Search by file name or by the in-game object name.
- Favourites: save any texture inside the program and reuse it in later builds.
- Projects (`.brpc`) remember packs, order and every choice.
- Light and dark theme, English and Russian interface.

## Download and run

Take `ResourcePackConstructor.exe` from the [Releases](../../releases) page and run it. Nothing to install: it needs only .NET Framework 4.x, which is part of Windows 10 and 11.

The program is not code-signed, so Windows may warn about an unknown publisher. Each release lists the SHA-256 checksum of the exe; you can compare it with `certutil -hashfile ResourcePackConstructor.exe SHA256` in a command prompt.

New versions are published on the same Releases page. To update, download the new exe and replace the old one — settings and favourites are kept.

## Build from source

The whole program is one file, `BRPC.cs`, and compiles with the C# compiler that ships with Windows — no Visual Studio or SDK required.

1. Download or clone this repository.
2. Double-click `build.bat`.
3. `ResourcePackConstructor.exe` appears next to it.
4. Optional: double-click `tools\check.bat` — it builds test packs and should end with «ПРОВЕРКА ПРОЙДЕНА».

Because of that compiler the code stays within C# 5. The program was written with the help of AI.

## Using built packs

A built pack is made of other people's work. It is for your own game only. Publish or share it only with the permission of the original authors — they are listed in the `credits` folder inside the pack and in its `manifest.json`.

## Files you load

Resource packs are made by other people and can contain anything. Load only packs and project files you trust. You are responsible for the files you load into the program and for the packs you build and share. The program is provided "as is", without warranty — see the [MIT license](LICENSE).

## Privacy

The program works offline. It has no accounts, no analytics, no crash reporting and makes no network connections. Nothing you load or create leaves your computer. The only links to the internet are buttons that open a page in your browser: PayPal in Settings, and GitHub/Discord under the pack list. From there the rules of those sites apply.

Project files (`.brpc`) store full paths to your packs, which may include your Windows user name — check before sharing a project file.

## Where it keeps its files

- Settings, favourites and manual layers: `%APPDATA%\BedrockPackStudio`
- Unpacked archives: the `BRPC-temp` folder next to the exe (if it cannot be written there — `%TEMP%\BRPC-temp`; very long paths — `%TEMP%\BRPC`). The program offers to clear them on exit: the `BRPC-temp` folder is emptied completely (do not keep your own files there), in `%TEMP%\BRPC` only the folders it created itself are deleted.
- Project files: wherever you save them.

The program never changes the packs you load, except when you edit a file in it yourself. It writes nothing to the registry.

## Uninstall

1. Close the program.
2. Delete `ResourcePackConstructor.exe` and the `BRPC-temp` folder next to it.
3. Delete `%APPDATA%\BedrockPackStudio` (save your favourites first if you need them), and `%TEMP%\BRPC-temp` and `%TEMP%\BRPC` if they exist.

## Support the project

The program is free. If you like it, there is a voluntary PayPal button in Settings (the gear). It is not a purchase and unlocks nothing. If you are under 18, ask your parents first.

## License

[MIT](LICENSE).

NOT AN OFFICIAL MINECRAFT PRODUCT. NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.

---

## По-русски

> **НЕОФИЦИАЛЬНЫЙ ПРОДУКТ MINECRAFT. НЕ ОДОБРЕН MOJANG ИЛИ MICROSOFT И НЕ СВЯЗАН С НИМИ.**

**Resource Pack Constructor** показывает загруженные пакеты текстур рядом, даёт выбрать для каждой текстуры вариант из любого пакета и собирает результат в один `.mcpack`. Программа в бета-версии: в целом работает, но проверены не все её части. Об ошибках пишите в [Issues](../../issues).

- Пакеты загружаются из папок, `.mcpack`, `.zip` и `.mcaddon` (пакеты Java-издания переводятся при загрузке); порядок меняется перетаскиванием, верхний важнее.
- Текстуры разложены по типам и категориям; щелчок выбирает вариант или выключает текстуру.
- Файлы JSON и `.lang` объединяются по содержимому, а не затирают друг друга.
- Слои PBR (отражения, свечение, рельеф) выбираются по отдельности из любого пакета; случайные варианты текстур блоков и мобов.
- Список 2D и 3D-вид блоков и мобов, собранных из текстур (для моделей мобов нужна установленная Minecraft для Windows).
- Встроенный редактор текстур: инструменты, выделение, фигуры, буфер обмена, коррекция цвета, симметрия и бесшовность, кадры анимации, 3D-вид во время правки.
- Избранное, проекты `.brpc`, светлая и тёмная тема, русский и английский язык.

**Запуск.** Скачайте `ResourcePackConstructor.exe` со страницы [Releases](../../releases). Устанавливать ничего не нужно. Программа не подписана цифровой подписью, поэтому Windows может предупредить о неизвестном издателе. У каждого выпуска указана контрольная сумма SHA-256 — её можно сверить командой `certutil -hashfile ResourcePackConstructor.exe SHA256`.

**Обновление.** Новые версии выкладываются на той же странице Releases: скачайте новый exe и замените им старый — настройки и избранное сохранятся.

**Использование собранных пакетов.** Собранный пакет состоит из чужих работ и предназначен только для вашей игры. Выкладывать или передавать его можно только с разрешения авторов исходных пакетов — они перечислены в папке `credits` внутри пакета и в его `manifest.json`.

**Файлы, которые вы загружаете.** Пакеты ресурсов делают другие люди, и в них может быть что угодно. Загружайте только те пакеты и файлы проектов, которым доверяете. За файлы, которые вы загружаете в программу, и за пакеты, которые собираете и передаёте другим, отвечаете вы. Программа предоставляется «как есть», без гарантий — см. [лицензию MIT](LICENSE).

**Конфиденциальность.** Программа работает без интернета: нет аккаунтов, аналитики, отчётов об ошибках, она не устанавливает сетевых соединений. То, что вы загружаете и создаёте, не покидает ваш компьютер. Ссылки в интернет — только кнопки, открывающие страницу в браузере: PayPal в настройках, GitHub и Discord под списком пакетов; дальше действуют правила этих сайтов. Файлы проектов `.brpc` хранят полные пути к пакетам, в них может быть имя пользователя Windows — проверьте, прежде чем делиться.

**Где программа хранит файлы.**
- Настройки, избранное, ручные слои: `%APPDATA%\BedrockPackStudio`.
- Распакованные архивы: папка `BRPC-temp` рядом с exe (если туда нельзя писать — `%TEMP%\BRPC-temp`; для очень длинных путей — `%TEMP%\BRPC`). При выходе программа предлагает их очистить: папка `BRPC-temp` очищается целиком (не храните в ней свои файлы), а в `%TEMP%\BRPC` удаляются только папки, которые создала сама программа.
- Файлы проектов: там, где вы их сохранили.

Программа не меняет загруженные пакеты, кроме файлов, которые вы сами правите в ней, и ничего не пишет в реестр.

**Удаление.** Закройте программу. Удалите `ResourcePackConstructor.exe` и папку `BRPC-temp` рядом с ним. Удалите `%APPDATA%\BedrockPackStudio` (сначала сохраните избранное, если оно нужно), а также `%TEMP%\BRPC-temp` и `%TEMP%\BRPC`, если они есть.

**Поддержка.** Программа бесплатна. Если она вам нравится, в настройках (шестерёнка) есть кнопка PayPal. Поддержка добровольная, это не покупка и ничего не открывает. Если вам меньше 18 лет, сначала спросите родителей.

**Сборка из исходного кода.** Дважды щёлкните `build.bat` — он соберёт `ResourcePackConstructor.exe` компилятором, который уже есть в Windows. `tools\check.bat` проверяет, что сборка пакетов работает. Программа написана с помощью ИИ.

Лицензия — [MIT](LICENSE).
