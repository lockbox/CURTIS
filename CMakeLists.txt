cmake_minimum_required(VERSION 3.19)

project(curtis-sigs LANGUAGES C CXX)

# all external sources should be under `./external`
set(EXTERNALS ${CMAKE_SOURCE_DIR}/external)

set(BSP_INCLUDES     
    external/ST_Library/Inc/
    external/CMSIS/Include/
    external/CMSIS/Device/ST/STM32F7xx/Include/)

# build all the projects that we need signatures from
include(cmake/freertos_memfault.cmake)
include(cmake/lua.cmake)
