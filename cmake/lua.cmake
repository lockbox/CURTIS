cmake_minimum_required(VERSION 3.12)
project(lua-static LANGUAGES C)

include(ExternalProject)

if (DEFINED $ENV{CURTIS_LUA_TAG})
    set(LUA_TAG $ENV{CURTIS_LUA_TAG})
else()
    set(LUA_TAG "v5.4.0")
endif() # defined CURTIS_LUA_TAG



# clone the lua code to `external/`
set(LUA_CLONE_PATH ${EXTERNALS}/lua)

set(srcDir ${LUA_CLONE_PATH})
set(includeDir ${LUA_CLONE_PATH})

# add all source files to the list
file(GLOB srcFiles ${srcDir}/*.c)
# remove luac.c because we don't need to bulid the compiler
list(FILTER srcFiles EXCLUDE REGEX "^.*luac.c$")

# add lua build target
add_library(lua STATIC
    ${srcFiles}
)

target_include_directories(lua PRIVATE external/lua)

target_compile_options(lua
    PRIVATE
    -Wextra -Wshadow -Wsign-compare -Wundef -Wwrite-strings -Wredundant-decls
    -Wdisabled-optimization -Waggregate-return -Wdouble-promotion -Wdeclaration-after-statement
    -Wmissing-prototypes -Wnested-externs -Wstrict-prototypes -Wc++-compat -Wold-style-definition
    ${CMAKE_C_FLAGS_DEBUG})

