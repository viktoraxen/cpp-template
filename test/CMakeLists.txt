find_package(GTest REQUIRED)

# TODO: Change project name. Add source files needed for tests
add_executable(TemplateTest main.cpp tests.cpp)

# TODO: Change project name
target_link_libraries(TemplateTest GTest::gtest GTest::gtest_main pthread)

# TODO: Change project name
target_include_directories(TemplateTest PRIVATE ${CMAKE_SOURCE_DIR}/include)

# TODO: Change project name
gtest_discover_tests(TemplateTest PROPERTIES ENVIRONMENT "GTEST_COLOR=1")
