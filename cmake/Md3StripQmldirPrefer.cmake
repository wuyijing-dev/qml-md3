# Remove "prefer :/qt/qml/..." from deployed qmldir so disk QML wins over empty qrc paths.
if (NOT DEFINED MD3_QML_DIR)
    message(FATAL_ERROR "Md3StripQmldirPrefer: MD3_QML_DIR not set")
endif()

set(_qmldir "${MD3_QML_DIR}/Md3/qmldir")
if (NOT EXISTS "${_qmldir}")
    return()
endif()

file(READ "${_qmldir}" _content)
string(REGEX REPLACE "prefer[^\n]*\n?" "" _content "${_content}")
file(WRITE "${_qmldir}" "${_content}")
