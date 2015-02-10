# variable for storing definitions
SET(DEFINITIONS_LIST "")


# macro which replaces add_definitions function and store all values to the DEFINITIONS_LIST
# e.g. RECORD_DEFINITIONS (-DFlow123d_DEBUG -std=c++11)
# e.g. RECORD_DEFINITIONS (-DFoo -DBar=123)
MACRO (RECORD_DEFINITIONS)
    SET(arg_list "${ARGN}")
    FOREACH(definition IN LISTS arg_list)
        MESSAGE (STATUS "Adding: ${definition}")
        LIST (APPEND DEFINITIONS_LIST "${definition}")
        add_definitions ("${definition}")
    ENDFOREACH()
ENDMACRO (RECORD_DEFINITIONS)



# MACRO for storing single definition with given name
# macro will also call add_definitions with -Dvariable_name=variable_value 
# if given varaiable name doesń't have any value, add_definitions(-Dvariable_name=0) 
# will be called
# e.g. RECORD_DEFINITIONS_BY_NAME ("GIT_BRANCH" "GIT_VERSION")
MACRO (RECORD_DEFINITIONS_BY_NAME)
    # put args into list
    SET(arg_list "${ARGN}")
    FOREACH(definition IN LISTS arg_list)
        IF(NOT "${definition}")
            RECORD_DEFINITIONS ("-D${definition}=0")
        else ()
            RECORD_DEFINITIONS ("-D${definition}=${${definition}}")
        endif ()
    ENDFOREACH()
ENDMACRO (RECORD_DEFINITIONS_BY_NAME)



# MACRO will append every definitions called by add_definitions
# into DEFINITIONS_LIST variable
MACRO (APPEND_DEFINITIONS_TO_LIST)
    get_directory_property (ORIG_DEFINITIONS DIRECTORY ${CMAKE_SOURCE_DIR} COMPILE_DEFINITIONS )
    LIST (APPEND DEFINITIONS_LIST "${ORIG_DEFINITIONS}")
ENDMACRO (APPEND_DEFINITIONS_TO_LIST)



# MACRO will generate definitions.tmp file in which all definition will be stored
# after that python script will expand this file into valid header file config.h
MACRO (GENERATE_CONFIG_H)
    # append every definitions called by add_definitions
    APPEND_DEFINITIONS_TO_LIST ()
    # write definitions
    FILE (WRITE "${CMAKE_BINARY_DIR}/definitions.tmp" "${DEFINITIONS_LIST}")
    # expand them using python script
    execute_process(COMMAND "python" "${CMAKE_SOURCE_DIR}/python/config_header.py" "-f" "${CMAKE_BINARY_DIR}/definitions.tmp" "-o" "${CMAKE_BINARY_DIR}/config.h.tmp")

    # copy if changed and delete tmp
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/config.h.tmp config.h)
    execute_process(COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_BINARY_DIR}/config.h.tmp)
    execute_process(COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_BINARY_DIR}/definitions.tmp)
ENDMACRO (GENERATE_CONFIG_H)