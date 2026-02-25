## Что такое Bison и Flex

**Flex** (Fast Lexical Analyzer) — генератор лексических анализаторов. По файлу с правилами (`.l`) он генерирует C-код, который читает текст и разбивает его на токены — именованные единицы: числа, ключевые слова, операторы и т.д.

**Bison** — генератор синтаксических анализаторов (парсеров). По файлу с грамматикой (`.y`) он генерирует C-код, который принимает поток токенов от Flex и строит из них дерево разбора, выполняя семантические действия (в нашем случае — сразу вычисляет результат).

Вместе они образуют классическую связку: **Flex → токены → Bison → выполнение**.

Инструкции по установке Bison, Flex и всех зависимостей для Windows и Linux/WSL — в файле [bison-flex-install.md](docs/bison-flex-install.md).

---

## Структура проекта

```
.
├── CMakeLists.txt          # сборочный скрипт
├── files/
│   ├── mini.l              # лексер (правила токенизации)
│   └── mini.y              # парсер (грамматика и интерпретация)
├── examples/
│   ├── valid/              # положительные примеры (корректные программы)
│   ├── invalid/            # негативные примеры (программы с ошибками)
│   └── run_tests.sh        # скрипт автоматической проверки примеров
├── docker/
│   ├── Dockerfile              # контейнер со всем окружением
│   ├── docker-entrypoint.sh    # точка входа контейнера (сборка + запуск)
│   └── bison-flex-install.md   # инструкции по установке инструментов
└── docs/
    └── bison-flex-install.md   # инструкции по установке инструментов

```

## Требования к сдаче задания

### Аргумент командной строки

Все программы **обязаны** принимать путь к файлу с программой на входном языке в качестве аргумента командной строки. Чтение через `stdin` не засчитывается.

```bash
# Правильно:
./build/main my_program.mini

# Неправильно:
./build/main < my_program.mini
```

### Примеры программ

Каждый студент обязан приложить к своему транслятору набор примеров в папке `examples/`:

**Положительные примеры** (`examples/valid/`) — корректные программы, которые транслятор должен принять и обработать без ошибок. Примеры должны покрывать все ключевые конструкции языка.

**Негативные примеры** (`examples/invalid/`) — программы с намеренными ошибками, на которых транслятор должен сообщить об ошибке и завершиться с ненулевым кодом возврата. Каждый файл должен содержать комментарий, объясняющий, какая именно ошибка в нём содержится.

Пример структуры:
```
examples/
├── valid/
│   ├── arithmetic.mini     # арифметические выражения
│   ├── conditionals.mini   # ветвления if/else
│   └── loops.mini          # циклы while
└── invalid/
    ├── missing_semicolon.mini   # ошибка: пропущена точка с запятой
    ├── unknown_token.mini       # ошибка: неизвестный символ
    └── unmatched_brace.mini     # ошибка: незакрытая скобка
```

---

## Сборка через CMake

Убедитесь, что Bison, Flex и CMake установлены (см. [bison-flex-install.md](bison-flex-install.md)), затем выполните:

```bash
cmake -B build
cmake --build build
```

**Запуск на Linux / WSL:**

```bash
./build/main ./examples/valid/test.mini
```

**Запуск на Windows:**

```powershell
.\build\Debug\main.exe .\examples\valid\test.mini
```

---

## Автоматическая проверка примеров

Скрипт `examples/run_tests.sh` прогоняет все файлы из `examples/valid/` и `examples/invalid/` через транслятор и проверяет коды возврата: для `valid/` ожидается успех (код `0`), для `invalid/` — ошибка (код `!= 0`).

```bash
./examples/run_tests.sh ./build/main
```

Пример вывода:

```
Транслятор: ./build/main
──────────────────────────────────────────
Положительные примеры (valid/):
  PASS  valid/arithmetic.mini
  PASS  valid/conditionals.mini
  FAIL  valid/loops.mini  ← транслятор вернул ошибку, ожидался успех

Негативные примеры (invalid/):
  PASS  invalid/missing_semicolon.mini
  PASS  invalid/unknown_token.mini

──────────────────────────────────────────
Итог: 4 прошло / 1 упало / 5 всего
```
---



## Сборка и запуск через Docker

Самый простой способ запустить проект без установки чего-либо вручную — использовать Docker.

### Сборка образа и запуск

```bash
docker compose -f docker/docker-compose.yml build tests
docker compose -f docker/docker-compose.yml run --rm tests
docker compose -f docker/docker-compose.yml run --rm translator run /workspace/examples/valid/test.mini
```

## Частые ошибки при сборке

**`Could NOT find BISON` или `Could NOT find FLEX`**  
Bison/Flex не найдены в `PATH`. См. [bison-flex-install.md](bison-flex-install.md).

**`mini.tab.hpp not found` при компиляции**  
Убедитесь, что в `CMakeLists.txt` есть `target_include_directories` с `${CMAKE_CURRENT_BINARY_DIR}`.