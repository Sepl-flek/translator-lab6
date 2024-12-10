cmake_minimum_required(VERSION 3.16)

project(ExampleParserWithFlexBison LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if ( NOT CMAKE_BUILD_TYPE )
    message( "Build Type not set, defaulting to Debug..." )
    set( CMAKE_BUILD_TYPE Debug )
endif()

if (NOT CMAKE_BUILD_TYPE EQUAL "Release")
    add_compile_options(-DYYDEBUG=1)
endif()

find_package(BISON)
find_package(FLEX)

BISON_TARGET(ExprParser files/expr.y ${CMAKE_CURRENT_BINARY_DIR}/expr.tab.cpp)
FLEX_TARGET(ExprScanner files/expr.l  ${CMAKE_CURRENT_BINARY_DIR}/lexpry.yy.cpp)
ADD_FLEX_BISON_DEPENDENCY(ExprScanner ExprParser)

include_directories(${CMAKE_CURRENT_BINARY_DIR}/out)
file(GLOB_RECURSE SOURCE_FILES out/*.cpp)
add_executable(main ${SOURCE_FILES}
               ${BISON_ExprParser_OUTPUTS}
               ${FLEX_ExprScanner_OUTPUTS}
               )

target_link_libraries(main ${FLEX_LIBRARIES})
target_include_directories(main PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
