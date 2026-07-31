cmake_minimum_required(VERSION 3.16)

if (NOT TARGET Md3)
    message(FATAL_ERROR "tests/smoke requires Md3 target")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick Test QuickTest)

# Prefer qmltestrunner from the same Qt kit
get_target_property(_qmake Qt6::qmake IMPORTED_LOCATION)
get_filename_component(_qt_bin "${_qmake}" DIRECTORY)
find_program(QMLTESTRUNNER_EXECUTABLE qmltestrunner HINTS "${_qt_bin}" REQUIRED)

set(_smoke_dir "${CMAKE_CURRENT_SOURCE_DIR}")
set(_import_paths "$<TARGET_FILE_DIR:Md3>;${CMAKE_BINARY_DIR}/src/Md3")

add_test(NAME md3_smoke_theme
    COMMAND ${QMLTESTRUNNER_EXECUTABLE}
        -input "${_smoke_dir}/tst_theme.qml"
        -import "${CMAKE_BINARY_DIR}/src/Md3"
)
add_test(NAME md3_smoke_button
    COMMAND ${QMLTESTRUNNER_EXECUTABLE}
        -input "${_smoke_dir}/tst_button.qml"
        -import "${CMAKE_BINARY_DIR}/src/Md3"
)
add_test(NAME md3_smoke_dialog
    COMMAND ${QMLTESTRUNNER_EXECUTABLE}
        -input "${_smoke_dir}/tst_dialog.qml"
        -import "${CMAKE_BINARY_DIR}/src/Md3"
)

add_test(NAME md3_smoke_pagehost
    COMMAND ${QMLTESTRUNNER_EXECUTABLE}
        -input "${_smoke_dir}/tst_pagehost.qml"
        -import "${CMAKE_BINARY_DIR}/src/Md3"
)

set_tests_properties(md3_smoke_theme md3_smoke_button md3_smoke_dialog md3_smoke_pagehost PROPERTIES
    ENVIRONMENT "QML2_IMPORT_PATH=${CMAKE_BINARY_DIR}/src/Md3;QT_QPA_PLATFORM=offscreen"
)
