# Header Generation Logic (ported from SPIRV-Tools/source/CMakeLists.txt)

find_package(Python3 REQUIRED)

set(VIMSYNTAX_PROCESSING_SCRIPT "${spirv-tools_SOURCE_DIR}/utils/vim/generate_syntax.py")
set(XML_REGISTRY_PROCESSING_SCRIPT "${spirv-tools_SOURCE_DIR}/utils/generate_registry_tables.py")
set(LANG_HEADER_PROCESSING_SCRIPT "${spirv-tools_SOURCE_DIR}/utils/generate_language_headers.py")
set(GGT_SCRIPT "${spirv-tools_SOURCE_DIR}/utils/ggt.py")

# Pull in grammar files that have migrated to SPIRV-Headers
set(GRAMMAR_DIR "${SPIRV_HEADERS_INCLUDE}/spirv/unified1")
set(SPIRV_CORE_GRAMMAR_JSON_FILE "${GRAMMAR_DIR}/spirv.core.grammar.json")
set(EI_debuginfo "${GRAMMAR_DIR}/extinst.debuginfo.grammar.json")
set(EI_cldebuginfo "${GRAMMAR_DIR}/extinst.opencl.debuginfo.100.grammar.json")
set(EI_glsl "${GRAMMAR_DIR}/extinst.glsl.std.450.grammar.json")
set(EI_opencl "${GRAMMAR_DIR}/extinst.opencl.std.100.grammar.json")
set(EI_amd_evp "${GRAMMAR_DIR}/extinst.spv-amd-shader-explicit-vertex-parameter.grammar.json")
set(EI_amd_trimm "${GRAMMAR_DIR}/extinst.spv-amd-shader-trinary-minmax.grammar.json")
set(EI_amd_gcn "${GRAMMAR_DIR}/extinst.spv-amd-gcn-shader.grammar.json")
set(EI_amd_ballot "${GRAMMAR_DIR}/extinst.spv-amd-shader-ballot.grammar.json")
set(EI_ns_debuginfo "${GRAMMAR_DIR}/extinst.nonsemantic.shader.debuginfo.100.grammar.json")
set(EI_ns_clspvreflect "${GRAMMAR_DIR}/extinst.nonsemantic.clspvreflection.grammar.json")
set(EI_ns_vkspreflect "${GRAMMAR_DIR}/extinst.nonsemantic.vkspreflection.grammar.json")
set(EI_tosa_001000_1 "${GRAMMAR_DIR}/extinst.tosa.001000.1.grammar.json")
set(EI_arm_motion_engine_100 "${GRAMMAR_DIR}/extinst.arm.motion-engine.100.grammar.json")

set(CORE_TABLES_BODY_INC_FILE ${spirv-tools_BINARY_DIR}/core_tables_body.inc)
set(CORE_TABLES_HEADER_INC_FILE ${spirv-tools_BINARY_DIR}/core_tables_header.inc)
add_custom_command(OUTPUT ${CORE_TABLES_BODY_INC_FILE} ${CORE_TABLES_HEADER_INC_FILE}
    COMMAND Python3::Interpreter ${GGT_SCRIPT}
      --core-tables-body-output=${CORE_TABLES_BODY_INC_FILE}
      --core-tables-header-output=${CORE_TABLES_HEADER_INC_FILE}
      --spirv-core-grammar=${SPIRV_CORE_GRAMMAR_JSON_FILE}
      --extinst=,${EI_glsl}
      --extinst=,${EI_opencl}
      --extinst=CLDEBUG100_,${EI_cldebuginfo}
      --extinst=SHDEBUG100_,${EI_ns_debuginfo}
      --extinst=,${EI_amd_evp}
      --extinst=,${EI_amd_trimm}
      --extinst=,${EI_amd_gcn}
      --extinst=,${EI_amd_ballot}
      --extinst=,${EI_debuginfo}
      --extinst=,${EI_ns_clspvreflect}
      --extinst=,${EI_ns_vkspreflect}
      --extinst=TOSA_,${EI_tosa_001000_1}
      --extinst=,${EI_arm_motion_engine_100}
    DEPENDS ${GGT_SCRIPT}
            ${SPIRV_CORE_GRAMMAR_JSON_FILE}
	    ${EI_glsl}
	    ${EI_opencl}
	    ${EI_cldebuginfo}
	    ${EI_ns_debuginfo}
	    ${EI_amd_evp}
	    ${EI_amd_trimm}
	    ${EI_amd_gcn}
	    ${EI_amd_ballot}
	    ${EI_debuginfo}
	    ${EI_ns_clspvreflect}
	    ${EI_ns_vkspreflect}
	    ${EI_tosa_001000_1}
	    ${EI_arm_motion_engine_100}
    COMMENT "Generate grammar tables")
add_custom_target(spirv-tools-tables DEPENDS ${CORE_TABLES_BODY_INC_FILE} ${CORE_TABLES_HEADER_INC_FILE})

macro(spvtools_extinst_lang_headers NAME GRAMMAR_FILE)
  set(OUT_H ${spirv-tools_BINARY_DIR}/${NAME}.h)
  add_custom_command(OUTPUT ${OUT_H}
    COMMAND Python3::Interpreter ${LANG_HEADER_PROCESSING_SCRIPT}
      --extinst-grammar=${GRAMMAR_FILE}
      --extinst-output-path=${OUT_H}
    DEPENDS ${LANG_HEADER_PROCESSING_SCRIPT} ${GRAMMAR_FILE}
    COMMENT "Generate language specific header for ${NAME}.")
  add_custom_target(spirv-tools-header-${NAME} DEPENDS ${OUT_H})
  # set_property(TARGET spirv-tools-header-${NAME} PROPERTY FOLDER "SPIRV-Tools build")
  list(APPEND EXTINST_CPP_DEPENDS spirv-tools-header-${NAME})
endmacro(spvtools_extinst_lang_headers)

spvtools_extinst_lang_headers("DebugInfo" ${EI_debuginfo})
spvtools_extinst_lang_headers("OpenCLDebugInfo100" ${EI_cldebuginfo})
spvtools_extinst_lang_headers("NonSemanticShaderDebugInfo100" ${EI_ns_debuginfo})

# Extract the list of known generators from the SPIR-V XML registry file.
set(GENERATOR_INC_FILE ${spirv-tools_BINARY_DIR}/generators.inc)
set(SPIRV_XML_REGISTRY_FILE ${SPIRV_HEADERS_INCLUDE}/spirv/spir-v.xml)
add_custom_command(OUTPUT ${GENERATOR_INC_FILE}
  COMMAND Python3::Interpreter ${XML_REGISTRY_PROCESSING_SCRIPT}
    --xml=${SPIRV_XML_REGISTRY_FILE}
    --generator-output=${GENERATOR_INC_FILE}
  DEPENDS ${XML_REGISTRY_PROCESSING_SCRIPT} ${SPIRV_XML_REGISTRY_FILE}
  COMMENT "Generate tables based on the SPIR-V XML registry.")
list(APPEND OPCODE_CPP_DEPENDS ${GENERATOR_INC_FILE})

add_custom_target(core_tables
  DEPENDS ${OPCODE_CPP_DEPENDS}
          spirv-tools-tables)
add_custom_target(extinst_tables
  DEPENDS ${EXTINST_CPP_DEPENDS})

set(SPIRV_TOOLS_BUILD_VERSION_INC
  ${spirv-tools_BINARY_DIR}/build-version.inc)
set(SPIRV_TOOLS_BUILD_VERSION_INC_GENERATOR
  ${spirv-tools_SOURCE_DIR}/utils/update_build_version.py)
set(SPIRV_TOOLS_CHANGES_FILE
  ${spirv-tools_SOURCE_DIR}/CHANGES)
add_custom_command(OUTPUT ${SPIRV_TOOLS_BUILD_VERSION_INC}
   COMMAND Python3::Interpreter
           ${SPIRV_TOOLS_BUILD_VERSION_INC_GENERATOR}
           ${SPIRV_TOOLS_CHANGES_FILE} ${SPIRV_TOOLS_BUILD_VERSION_INC}
   DEPENDS ${SPIRV_TOOLS_BUILD_VERSION_INC_GENERATOR}
           ${SPIRV_TOOLS_CHANGES_FILE}
   COMMENT "Update build-version.inc in the SPIRV-Tools build directory (if necessary).")
add_custom_target(spirv-tools-build-version
   DEPENDS ${SPIRV_TOOLS_BUILD_VERSION_INC})
