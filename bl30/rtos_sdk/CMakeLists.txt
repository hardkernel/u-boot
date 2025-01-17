enable_language(C CXX ASM)

add_subdirectory(arch/${ARCH})
add_subdirectory(boards/${ARCH})
add_subdirectory(drivers_aocpu)
add_subdirectory(kernel/freertos)
add_subdirectory(lib/libc)
add_subdirectory(soc/${ARCH})
