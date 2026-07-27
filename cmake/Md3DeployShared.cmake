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

    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        if (EXISTS "${_md3_dll_debug}")
            set(_md3_runtime_dll "${_md3_dll_debug}")
            set(_md3_runtime_qml "${_md3_qml_debug}")
        else()
            message(WARNING
                "Md3: building ${target} in Debug but the Md3 package has no bin/debug/Md3.dll.\n"
                "  Qt Creator Debug kits will fail to load Md3 (debug/release DLL mismatch).\n"
                "  Fix: use a Release kit, or repackage with scripts/package-windows.ps1 (builds Debug variant automatically).")
            set(_md3_runtime_dll "${_md3_dll_release}")
            set(_md3_runtime_qml "${_md3_qml_release}")
        endif()
    else()
        set(_md3_runtime_dll "${_md3_dll_release}")
        set(_md3_runtime_qml "${_md3_qml_release}")
    endif()

    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${_md3_runtime_dll}" "$<TARGET_FILE_DIR:${target}>"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
            "${_md3_runtime_qml}" "$<TARGET_FILE_DIR:${target}>/qml"
        COMMENT "Deploy shared Md3 (${CMAKE_BUILD_TYPE}) beside ${target}"
    )
endfunction()
