cmake_minimum_required(VERSION 3.16)
project(ExampleProject LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Найти Bison и Flex
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# Сгенерировать parser.cpp и parser.h из parser.y
bison_target(miniParser files/mini.y ${CMAKE_CURRENT_BINARY_DIR}/mini.tab.cpp)

if(WIN32)
  set(FLEX_FLAGS --wincompat)
endif()
# Сгенерировать lexer.cpp из lexer.l
flex_target(
  miniScanner #
  files/mini.l #
  ${CMAKE_CURRENT_BINARY_DIR}/lminiy.yy.cpp #
  COMPILE_FLAGS "${FLEX_FLAGS}")

# Сказать CMake, что лексер зависит от заголовка парсера
add_flex_bison_dependency(miniScanner miniParser)

# Собрать исполняемый файл
add_executable(main
    main.cpp
    ${BISON_miniParser_OUTPUTS}
    ${FLEX_miniScanner_OUTPUTS}
)

target_include_directories(main PRIVATE ${CMAKE_CURRENT_BINARY_DIR}
                                        ${CMAKE_CURRENT_BINARY_DIR}/out)
