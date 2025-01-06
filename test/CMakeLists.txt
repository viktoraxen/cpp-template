find_package(GTest REQUIRED)

# TODO: Add source files needed for tests
add_executable(TemplateTest main.cpp tests.cpp)

target_link_libraries(TemplateTest GTest::gtest GTest::gtest_main pthread)

target_include_directories(TemplateTest PRIVATE ${CMAKE_SOURCE_DIR}/include)

gtest_discover_tests(TemplateTest PROPERTIES ENVIRONMENT "GTEST_COLOR=1")
