cmake_minimum_required(VERSION 3.16)
project(tint_extract CXX)

set(TINT_DIR "${CMAKE_SOURCE_DIR}/src/tint")
set(SPIRV_TOOLS "SPIRV-Tools")
set(SPIRV_TOOLS_DIR "${CMAKE_SOURCE_DIR}/${SPIRV_TOOLS}")
set(SPIRV_HEADERS_DIR "${CMAKE_SOURCE_DIR}/spirv-headers")
#set(SPIRV-Headers_SOURCE_DIR "${SPIRV_HEADERS_DIR}")

# -------- toolchain / flags ----------------------------------------------------
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(MSVC)
  add_compile_options(/W3)
else()
  add_compile_options(-Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers)
endif()

# -------- helper: glob sources + filter out tests/fuzz/bench -------------------
function(glob_filtered out_var)
  # Usage: glob_filtered(VAR <globs...>)
  set(_accum)
  foreach(_pat ${ARGN})
    file(GLOB_RECURSE _tmp CONFIGURE_DEPENDS ${_pat})
    list(APPEND _accum ${_tmp})
  endforeach()
  # remove obvious non-build trees
  foreach(_x ${_accum})
    if(_x MATCHES "(test|tests|fuzz|fuzzer|benchmark|bench|samples|examples|windows)(/|.cc)")
      list(REMOVE_ITEM _accum ${_x})
    endif()
  endforeach()
  set(${out_var} "${_accum}" PARENT_SCOPE)
endfunction()

# -------- SPIRV-Headers (headers only) ----------------------------------------
set(SPIRV_HEADERS_INCLUDE "${SPIRV_HEADERS_DIR}/include")
if(NOT EXISTS "${SPIRV_HEADERS_INCLUDE}")
  message(FATAL_ERROR "SPIRV-Headers include dir not found at ${SPIRV_HEADERS_INCLUDE}")
endif()

# -------- SPIRV-Tools (static lib) --------------------------------------------

include_directories(
  "${CMAKE_BINARY_DIR}/${SPIRV_TOOLS}"
)

include(cmake/SPIRV-Tools-minimal.cmake)

# -------- Tint (static lib) ----------------------------------------------------
glob_filtered(TINT_SOURCES
  "${TINT_DIR}/api/tint.cc"
  "${TINT_DIR}/cmd/common/helper.cc"
  "${TINT_DIR}/utils/memory/memory.cc"
  "${TINT_DIR}/utils/bytes/buffer_reader.cc"
  "${TINT_DIR}/utils/args.cc"
  "${TINT_DIR}/utils/cli.cc"
  "${TINT_DIR}/utils/result.cc"
  "${TINT_DIR}/utils/command/args.cc"
  "${TINT_DIR}/utils/ice/ice.cc"
  "${TINT_DIR}/utils/ice/debugger.cc"
  "${TINT_DIR}/utils/diagnostic/diagnostic.cc"
  "${TINT_DIR}/utils/diagnostic/formatter.cc"
  "${TINT_DIR}/utils/diagnostic/source.cc"
  "${TINT_DIR}/utils/symbol/symbol.cc"
  "${TINT_DIR}/utils/symbol/symbol_table.cc"
  "${TINT_DIR}/utils/symbol/generation_id.cc"
  "${TINT_DIR}/utils/system/terminal_other.cc"
  "${TINT_DIR}/utils/system/env_other.cc"
  "${TINT_DIR}/utils/text/*.cc"
  "${TINT_DIR}/utils/text_generator/*.cc"
  "${TINT_DIR}/utils/rtti/castable.cc"
  "${TINT_DIR}/utils/rtti/switch.cc"
  "${TINT_DIR}/utils/strconv/float_to_string.cc"
  "${TINT_DIR}/lang/core/*.cc"
  "${TINT_DIR}/lang/core/**/*.cc"
  "${TINT_DIR}/lang/core/**/**/*.cc"
  "${TINT_DIR}/lang/spirv/*.cc"
  "${TINT_DIR}/lang/spirv/**/*.cc"
  "${TINT_DIR}/lang/spirv/**/**/*.cc"
  "${TINT_DIR}/lang/wgsl/*.cc"
  "${TINT_DIR}/lang/wgsl/**/*.cc"
  "${TINT_DIR}/lang/wgsl/**/**/*.cc"
)
add_library(tint-lib STATIC ${TINT_SOURCES})
target_include_directories(tint-lib PUBLIC
  "${TINT_DIR}"
  "${CMAKE_SOURCE_DIR}"
  "${SPIRV_TOOLS_DIR}"
  "${SPIRV_TOOLS_DIR}/include"
  "${SPIRV_HEADERS_INCLUDE}"
  "${CMAKE_BINARY_DIR}/${SPIRV_TOOLS}"
)
# Link against SPIRV-Tools if the extracted tree includes SPIR-V reader/writer
target_link_libraries(tint-lib PUBLIC spirv-tools-minimal)

# Some Tint builds expect this on Windows; harmless elsewhere:
target_compile_definitions(tint-lib PUBLIC TINT_BUILD_SPV_READER=1 TINT_BUILD_WGSL_WRITER=1)

# Common locations in Tint tree:
set(_tint_cli_src "")
if(EXISTS "${TINT_DIR}/cmd/tint/main.cc")
  set(_tint_cli_src "${TINT_DIR}/cmd/tint/main.cc")
elseif(EXISTS "${TINT_DIR}/cmd/main.cc")
  set(_tint_cli_src "${TINT_DIR}/cmd/main.cc")
endif()

if(_tint_cli_src)
  add_executable(tint-cli ${_tint_cli_src})
  target_link_libraries(tint-cli PRIVATE tint-lib)
  target_link_options(tint-cli PRIVATE -fno-rtti -fno-exceptions)
  set_target_properties(tint-cli PROPERTIES OUTPUT_NAME "tint")
  message(STATUS "Building 'tint' CLI from ${_tint_cli_src}")
else()
  message(STATUS "No 'tint' CLI entry point found; building library only.")
endif()

add_subdirectory(tests)

