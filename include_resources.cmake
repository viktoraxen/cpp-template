# Source and destination directories
set(RESOURCE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/res)
set(RESOURCE_DEST_DIR ${CMAKE_BINARY_DIR}/res)

add_custom_target(
  copy_resources ALL
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${RESOURCE_DEST_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${RESOURCE_SOURCE_DIR}
          ${RESOURCE_DEST_DIR}
  COMMENT "Copying resources to build directory")
