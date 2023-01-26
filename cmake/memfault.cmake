cmake_minimum_required(VERSION 3.19)
project(memfault-sdk-static LANGUAGES C)

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


add_library(memfault_static
    STATIC
    ${MEMFAULT_COMPONENTS_SRCS}
    ${FREERTOS_MEMFAULT_SRCS}
)    


target_include_directories(memfault_static
    PUBLIC
    ${MEMFAULT_COMPONENTS_INC_FOLDERS}
    ${MEMFAULT_SDK_ROOT}/ports/include
    ${MEMFAULT_PORT_ROOT}
    curtis/include
    ${BSP_INCLUDES}
    ${FREERTOS_KERNEL_INCLUDES}
    ${FREERTOS_KERNEL_PORT_INCLUDES}
)

target_compile_options(memfault_static PUBLIC ${CMAKE_C_FLAGS_DEBUG})
