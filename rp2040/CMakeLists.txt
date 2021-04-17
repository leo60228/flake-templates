cmake_minimum_required(VERSION 3.18)

include(pico_sdk_import.cmake)

project(my_project)

pico_sdk_init()

add_executable(my_project
    main.c
)

target_link_libraries(my_project pico_stdlib)

pico_add_extra_outputs(my_project)
pico_enable_stdio_usb(my_project 1)
pico_enable_stdio_uart(my_project 0)

configure_file(flash.jlink ${CMAKE_CURRENT_BINARY_DIR}/flash.jlink)

add_custom_target(flash
    COMMAND JLinkExe -if SWD -device RP2040_M0_0 -speed 4000 -autoconnect 1 -CommanderScript ${CMAKE_CURRENT_BINARY_DIR}/flash.jlink
    DEPENDS my_project
)
