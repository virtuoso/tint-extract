
add_custom_target(run-tests
    COMMAND ${CMAKE_BINARY_DIR}/tint ${CMAKE_CURRENT_SOURCE_DIR}/test.spvasm -o ${CMAKE_CURRENT_BINARY_DIR}/test_output.wgsl
    COMMAND diff ${CMAKE_CURRENT_BINARY_DIR}/test_output.wgsl ${CMAKE_CURRENT_SOURCE_DIR}/test.wgsl
    COMMENT "Running tint test and comparing output"
    DEPENDS tint-cli
)
