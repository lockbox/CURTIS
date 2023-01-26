cmake_minimum_required(VERSION 3.19)

project(free_rtos_memfault_static LANGUAGES C)

include(FetchContent)

##########
# Start Memfault Setup
##########

# set globals for memfault cmake function
set(MEMFAULT_SDK_ROOT ${EXTERNALS}/memfault)
set(MEMFAULT_PORT_ROOT ${MEMFAULT_SDK_ROOT}/ports/freertos)
include(${MEMFAULT_SDK_ROOT}/cmake/Memfault.cmake)

# enable all of the components
list(APPEND MEMFAULT_COMPONENTS core util panics metrics)

# call the memfault function to setup the library
memfault_library(${MEMFAULT_SDK_ROOT} MEMFAULT_COMPONENTS
 MEMFAULT_COMPONENTS_SRCS MEMFAULT_COMPONENTS_INC_FOLDERS)

file(GLOB FREERTOS_MEMFAULT_SRCS ${MEMFAULT_PORT_ROOT}/src/*.c)

##########
# End Memfault Setup
##########

if (DEFINED $ENV{CURTIS_FREE_RTOS_TAG})
    set(FREE_RTOS_TAG $ENV{CURTIS_FREE_RTOS_TAG})
else()
    set(FREE_RTOS_TAG "main")
endif() # defined CURTIS_FREE_RTOS_TAG

# expose freertos_config as interface so the kernel can
# link against it
add_library(freertos_config INTERFACE)

# must pass the path to the directory containing "FreeRTOSConfig.h"
target_include_directories(freertos_config SYSTEM
    INTERFACE
    curtis/include/
    ${BSP_INCLUDES}
    ${MEMFAULT_COMPONENTS_INC_FOLDERS}
    ${MEMFAULT_SDK_ROOT}/ports/include
    ${MEMFAULT_PORT_ROOT}
)

file(GLOB ST_LIBRARY_SRC external/ST_Library/Src/*.c)
target_sources(freertos_config
    INTERFACE
    ${ST_LIBRARY_SRC}
    ${MEMFAULT_COMPONENTS_SRCS}
    ${FREERTOS_MEMFAULT_SRCS}
    external/CMSIS/Device/ST/STM32F7xx/Source/Templates/system_stm32f7xx.c
)

target_compile_definitions(freertos_config
    INTERFACE
    projCOVERAGE_TEST=0
    USE_HAL=1
    CORE_CM7=1
    STM32F746xx=1
)

# get free rtos
FetchContent_Declare( 
  freertos_kernel
  GIT_REPOSITORY https://github.com/FreeRTOS/FreeRTOS-Kernel.git
  GIT_TAG        ${FREE_RTOS_TAG}
)

# set freertos configure options
set(FREERTOS_HEAP "4" CACHE STRING "" FORCE)
set(FREERTOS_PORT "GCC_ARM_CM4_MPU" CACHE STRING "" FORCE)

target_compile_options(freertos_config INTERFACE ${CMAKE_C_FLAGS_DEBUG})

# build and expose freertos kernel
FetchContent_MakeAvailable(freertos_kernel)
