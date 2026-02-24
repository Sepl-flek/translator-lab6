# Установка Bison и Flex

Bison и Flex — основные инструменты для этого занятия. Мы будем вызывать их через CMake, который сам найдёт установленные программы.

---

## Windows

На Windows нет нативных `bison` и `flex`, поэтому используется **WinFlexBison** — официальный Windows-порт. CMake находит `win_bison` и `win_flex` автоматически, специальной настройки не требуется.

### 1. Bison и Flex (WinFlexBison)

**Способ А — через winget (рекомендуется)**

Откройте **PowerShell от имени администратора** и выполните:

```powershell
winget install -e --id WinFlexBison.win_flex_bison
```

WinFlexBison автоматически добавится в PATH.

---

**Способ Б — вручную (если winget недоступен)**

Скачайте архив (файл предоставит преподаватель, либо по прямой ссылке):
```
https://github.com/lexxmark/winflexbison/releases/download/v2.5.25/win_flex_bison-2.5.25.zip
```

Распакуйте в папку без пробелов в пути, и добавьте папку в PATH:

1. Нажмите `Win + R`, введите `sysdm.cpl`, нажмите OK
2. Вкладка **"Дополнительно"** → **"Переменные среды"**
3. В разделе **"Системные переменные"** найдите `Path` → **"Изменить"** → **"Создать"**
4. Введите: `C:\tools\winflexbison`
5. Нажмите OK во всех окнах


> **Важно:** не перемещайте `win_bison.exe` отдельно — рядом обязательно должна быть папка `data\`.


---

Проверьте в новом окне PowerShell:
```powershell
win_bison --version
win_flex --version
```

---

### 2. CMake (если ещё не установлен)

```powershell
winget install -ie --id Kitware.CMake
```

---

### 3. Компилятор LLVM/Clang (если нужен)

> Этот шаг нужен только если у вас нет компилятора C/C++. Если установлена Visual Studio — пропустите.

Сначала установите линковщик и заголовки Windows (без них Clang не умеет собирать `.exe`):

```powershell
winget install -ie --id Microsoft.VCRedist.2015+.x64
winget install -ie --id Microsoft.VisualStudio.2022.BuildTools
```

В открывшемся установщике выберите **"Desktop development with C++"** и нажмите **Install**.

Затем установите сам Clang:

**Способ А — через winget:**
```powershell
winget install -ie --id LLVM.LLVM --scope machine
```
В процессе установки выберите **"Add LLVM to the system PATH for all users"**.

**Способ Б — вручную**:
```
https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/LLVM-21.1.8-win64.exe
```
Запустите установщик и на шаге выбора PATH выберите **"Add LLVM to the system PATH for all users"**.

> Если winget был недоступен и зависимости тоже не были установлены — см. следующий раздел.

---

### Ручная установка зависимостей LLVM (если winget недоступен)

Clang требует два компонента: **VC++ Redistributable** (runtime-библиотеки) и **Visual Studio Build Tools** (линковщик и заголовки). Без них Clang устанавливается, но не может собирать `.exe`.

#### Visual C++ Redistributable и Visual Studio Build Tools 2022

Скачайте по постоянной ссылке Microsoft — она всегда указывает на актуальную версию:

```
https://aka.ms/vs/17/release/vc_redist.x64.exe
https://aka.ms/vs/17/release/vs_buildtools.exe
```

После этого установите сам Clang (Способ Б выше) — он найдёт линковщик автоматически.

---

Проверьте:
```powershell
clang --version
```

---

## Linux

### 1. Bison и Flex

**Debian / Ubuntu:**
```bash
sudo apt update
sudo apt install bison flex
```

**Fedora / RHEL / CentOS:**
```bash
sudo dnf install bison flex
```

**Arch Linux:**
```bash
sudo pacman -S bison flex
```

Проверьте:
```bash
bison --version
flex --version
```

---

### 2. CMake (если ещё не установлен)

**Debian / Ubuntu:**
```bash
sudo apt install cmake
```

**Fedora:**
```bash
sudo dnf install cmake
```

---

### 3. Компилятор LLVM/Clang (если нужен)

> Этот шаг нужен только если у вас нет компилятора C/C++. Если установлен GCC — пропустите.

**Debian / Ubuntu:**
```bash
sudo apt install clang
```

**Fedora:**
```bash
sudo dnf install clang
```

Проверьте:
```bash
clang --version
```

---

