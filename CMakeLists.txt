cmake_minimum_required(VERSION 3.9)

project(posixmq VERSION 1.0.0 DESCRIPTION "POSIX Message Queue exposer")
add_library(posixmq SHARED
    src/posixmq.cpp
    )

set_target_properties(posixmq PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(posixmq PROPERTIES SOVERSION 1)
set_target_properties(posixmq PROPERTIES COMPILE_FLAGS "-m32 -lrt" LINK_FLAGS "-m32 -lrt")

