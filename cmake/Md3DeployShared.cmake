# Deploy shared Md3 runtime (DLL + QML tree) beside a consumer executable.
# Handles Debug vs Release: package-windows.ps1 stages Debug under bin/debug + lib/qml-debug.
function(md3_deploy_shared_runtime target md3_dir)
    if (NOT WIN32)
        return()
    endif()
    if (NOT EXISTS "${md3_dir}/bin/Md3.dll")
        return()
    endif()

    set(_md3_dll_release "${md3_dir}/bin/Md3.dll")
    set(_md3_dll_debug "${md3_dir}/bin/debug/Md3.dll")
    set(_md3_qml_release "${md3_dir}/lib/qml")
    set(_md3_qml_debug "${md3_dir}/lib/qml-debug")
    set(_strip_script "${md3_dir}/lib/cmake/Md3/Md3StripQmldirPrefer.cmake")

    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        if (EXISTS "${_md3_dll_debug}")
            set(_md3_runtime_dll "${_md3_dll_debug}")
            set(_md3_runtime_qml "${_md3_qml_debug}")
        else()
            message(FATAL_ERROR
                "Md3: Debug build of ${target} requires bin/debug/Md3.dll in the Md3 package.\n"
                "  Your package only has Release Md3.dll — loading it crashes at startup (0xC0000139).\n"
                "  Fix: switch Qt Creator to Release, or repackage:\n"
                "    cd QML_MD3 && .\\scripts\\package-windows.ps1\n"
                "  then copy dist/Md3 into your project's Md3/ folder.")
        endif()
    else()
        set(_md3_runtime_dll "${_md3_dll_release}")
        set(_md3_runtime_qml "${_md3_qml_release}")
    endif()

    if (NOT EXISTS "${_strip_script}")
        set(_strip_script "${CMAKE_CURRENT_LIST_DIR}/Md3StripQmldirPrefer.cmake")
    endif()

    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${_md3_runtime_dll}" "$<TARGET_FILE_DIR:${target}>"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
            "${_md3_runtime_qml}" "$<TARGET_FILE_DIR:${target}>/qml"
        COMMAND ${CMAKE_COMMAND}
            -DMD3_QML_DIR=$<TARGET_FILE_DIR:${target}>/qml
            -P "${_strip_script}"
        COMMENT "Deploy shared Md3 (${CMAKE_BUILD_TYPE}) beside ${target}"
    )
endfunction()
