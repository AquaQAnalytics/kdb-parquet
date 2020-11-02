set(command "/snap/cmake/619/bin/cmake;-P;/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/src/thrift_ep-prefix/src/thrift_ep-stamp/download-thrift_ep.cmake")

execute_process(COMMAND ${command} RESULT_VARIABLE result)
if(result)
  set(msg "Command failed (${result}):\n")
  foreach(arg IN LISTS command)
    set(msg "${msg} '${arg}'")
  endforeach()
  message(FATAL_ERROR "${msg}")
endif()
set(command "/snap/cmake/619/bin/cmake;-P;/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/src/thrift_ep-prefix/src/thrift_ep-stamp/verify-thrift_ep.cmake")

execute_process(COMMAND ${command} RESULT_VARIABLE result)
if(result)
  set(msg "Command failed (${result}):\n")
  foreach(arg IN LISTS command)
    set(msg "${msg} '${arg}'")
  endforeach()
  message(FATAL_ERROR "${msg}")
endif()
set(command "/snap/cmake/619/bin/cmake;-P;/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/src/thrift_ep-prefix/src/thrift_ep-stamp/extract-thrift_ep.cmake")

execute_process(COMMAND ${command} RESULT_VARIABLE result)
if(result)
  set(msg "Command failed (${result}):\n")
  foreach(arg IN LISTS command)
    set(msg "${msg} '${arg}'")
  endforeach()
  message(FATAL_ERROR "${msg}")
endif()
