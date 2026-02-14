# Minimal SPIRV-Tools build for Tint
# This script defines a 'spirv-tools-minimal' target that includes only the necessary
# object files from SPIRV-Tools and SPIRV-Tools-opt to support Tint's SPV reader.

# We assume SPIRV-Tools source tree is available at ${SPIRV_TOOLS_DIR}
set(SPIRV_TOOLS_SOURCE_DIR "${SPIRV_TOOLS_DIR}/source")
set(spirv-tools_SOURCE_DIR "${SPIRV_TOOLS_DIR}")
set(spirv-tools_BINARY_DIR "${CMAKE_BINARY_DIR}/${SPIRV_TOOLS}")

# -------- Header Generation Logic --------
include(cmake/SPIRV-Tools-header-gen.cmake)
# -------- End Header Generation Logic --------

# Source files for SPIRV-Tools core
set(SPIRV_TOOLS_MINIMAL_SOURCES
  ${SPIRV_TOOLS_SOURCE_DIR}/util/bit_vector.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/util/parse_number.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/util/string_utils.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/assembly_grammar.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/binary.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/diagnostic.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/disassemble.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/ext_inst.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/extensions.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/libspirv.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/name_mapper.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opcode.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/operand.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/parsed_operand.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/print.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/software_version.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/spirv_endian.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/spirv_fuzzer_options.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/spirv_optimizer_options.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/spirv_reducer_options.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/spirv_target_env.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/spirv_validator_options.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/table.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/table2.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/text.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/text_handler.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/to_string.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_adjacency.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_annotation.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_arithmetics.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_atomics.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_barriers.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_bitwise.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_builtins.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_capability.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_cfg.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_composites.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_constants.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_conversion.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_debug.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_decorations.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_derivatives.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_dot_product.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_extensions.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_execution_limitations.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_function.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_graph.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_group.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_id.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_image.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_interfaces.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_instruction.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_layout.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_literals.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_logicals.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_logical_pointers.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_memory.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_memory_semantics.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_mesh_shading.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_misc.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_mode_setting.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_non_uniform.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_primitives.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_ray_query.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_ray_tracing.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_ray_tracing_reorder.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_scopes.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_small_type_uses.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_tensor_layout.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_tensor.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_type.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validate_invalid_type.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/basic_block.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/construct.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/function.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/instruction.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/val/validation_state.cpp
)

# Reduced Source files for SPIRV-Tools-opt
# Included only what is needed by:
# - SplitCombinedImageSamplerPass
# - ResolveBindingConflictsPass
# - BuildModule
set(SPIRV_TOOLS_OPT_SOURCES
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/basic_block.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/build_module.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/cfg.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/constants.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/debug_info_manager.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/decoration_manager.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/def_use_manager.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/dominator_analysis.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/dominator_tree.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/feature_manager.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/function.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/instruction.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/instruction_list.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/ir_context.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/ir_loader.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/module.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/optimizer.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/pass.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/pass_manager.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/resolve_binding_conflicts_pass.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/split_combined_image_sampler_pass.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/type_manager.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/types.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/loop_descriptor.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/value_number_table.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/struct_cfg_analysis.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/scalar_analysis.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/scalar_analysis_simplification.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/graph.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/liveness.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/fold.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/folding_rules.cpp
  ${SPIRV_TOOLS_SOURCE_DIR}/opt/const_folding_rules.cpp
)

# Define the minimal target
add_library(spirv-tools-minimal STATIC ${SPIRV_TOOLS_MINIMAL_SOURCES} ${SPIRV_TOOLS_OPT_SOURCES})

# Include directories
target_include_directories(spirv-tools-minimal PUBLIC
  "${SPIRV_TOOLS_DIR}/include"
  "${SPIRV_TOOLS_DIR}"
  "${SPIRV_HEADERS_INCLUDE}"
  "${CMAKE_BINARY_DIR}/${SPIRV_TOOLS}"
)

# Defines
target_compile_definitions(spirv-tools-minimal PUBLIC
  SPIRV_TOOLS_IMPLEMENTATION
  SPIRV_TOOLS_SHAREDLIB=0
)

# Dependencies on generated files
add_dependencies(spirv-tools-minimal spirv-tools-build-version core_tables extinst_tables)
