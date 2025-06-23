cmake_minimum_required(VERSION 3.10)

project(Template)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(Template src/main.cpp)

get_target_property(EXECUTABLE_OUTPUT_NAME Template OUTPUT_NAME)

if(NOT EXECUTABLE_OUTPUT_NAME)
  set(EXECUTABLE_OUTPUT_NAME "Template")
endif()

file(WRITE ${CMAKE_BINARY_DIR}/.executable_name "${EXECUTABLE_OUTPUT_NAME}")

target_include_directories(Template PRIVATE ${CMAKE_SOURCE_DIR}/include)
