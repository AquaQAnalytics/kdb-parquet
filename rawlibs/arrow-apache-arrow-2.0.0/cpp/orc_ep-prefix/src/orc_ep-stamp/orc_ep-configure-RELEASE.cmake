
cmake_minimum_required(VERSION 3.15)

set(command "/snap/cmake/619/bin/cmake;-DCMAKE_C_COMPILER=/usr/bin/cc;-DCMAKE_CXX_COMPILER=/usr/bin/c++;-DCMAKE_AR=/usr/bin/ar;-DCMAKE_RANLIB=/usr/bin/ranlib;-DCMAKE_BUILD_TYPE=RELEASE;-DCMAKE_C_FLAGS= -O3 -DNDEBUG -O3 -DNDEBUG -fPIC;-DCMAKE_C_FLAGS_RELEASE= -O3 -DNDEBUG -O3 -DNDEBUG -fPIC;-DCMAKE_CXX_FLAGS= -fdiagnostics-color=always -O3 -DNDEBUG -O3 -DNDEBUG -fPIC;-DCMAKE_CXX_FLAGS_RELEASE= -fdiagnostics-color=always -O3 -DNDEBUG -O3 -DNDEBUG -fPIC;-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=;-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=;-DCMAKE_INSTALL_PREFIX=/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/orc_ep-install;-DCMAKE_CXX_FLAGS= -fdiagnostics-color=always -O3 -DNDEBUG -O3 -DNDEBUG -fPIC;-DSTOP_BUILD_ON_WARNING=OFF;-DBUILD_LIBHDFSPP=OFF;-DBUILD_JAVA=OFF;-DBUILD_TOOLS=OFF;-DBUILD_CPP_TESTS=OFF;-DINSTALL_VENDORED_LIBS=OFF;-DSNAPPY_HOME=/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/snappy_ep/src/snappy_ep-install;-DSNAPPY_INCLUDE_DIR=/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/snappy_ep/src/snappy_ep-install/include;-DPROTOBUF_HOME=/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/protobuf_ep-install;-DPROTOBUF_INCLUDE_DIR=/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/protobuf_ep-install/include;-DPROTOBUF_LIBRARY=/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/protobuf_ep-install/lib/libprotobuf.a;-DPROTOC_LIBRARY=/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/protobuf_ep-install/lib/libprotobuf.a;-DLZ4_HOME=;-DZSTD_HOME=;-GUnix Makefiles;/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/orc_ep-prefix/src/orc_ep")
set(log_merged "")
set(log_output_on_failure "1")
set(stdout_log "/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/orc_ep-prefix/src/orc_ep-stamp/orc_ep-configure-out.log")
set(stderr_log "/home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/orc_ep-prefix/src/orc_ep-stamp/orc_ep-configure-err.log")
execute_process(
  COMMAND ${command}
  RESULT_VARIABLE result
  OUTPUT_FILE "${stdout_log}"
  ERROR_FILE "${stderr_log}"
  )
macro(read_up_to_max_size log_file output_var)
  file(SIZE ${log_file} determined_size)
  set(max_size 10240)
  if (determined_size GREATER max_size)
    math(EXPR seek_position "${determined_size} - ${max_size}")
    file(READ ${log_file} ${output_var} OFFSET ${seek_position})
    set(${output_var} "...skipping to end...\n${${output_var}}")
  else()
    file(READ ${log_file} ${output_var})
  endif()
endmacro()
if(result)
  set(msg "Command failed: ${result}\n")
  foreach(arg IN LISTS command)
    set(msg "${msg} '${arg}'")
  endforeach()
  if (${log_merged})
    set(msg "${msg}\nSee also\n  ${stderr_log}")
  else()
    set(msg "${msg}\nSee also\n  /home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/orc_ep-prefix/src/orc_ep-stamp/orc_ep-configure-*.log")
  endif()
  if (${log_output_on_failure})
    message(SEND_ERROR "${msg}")
    if (${log_merged})
      read_up_to_max_size("${stderr_log}" error_log_contents)
      message(STATUS "Log output is:\n${error_log_contents}")
    else()
      read_up_to_max_size("${stdout_log}" out_log_contents)
      read_up_to_max_size("${stderr_log}" err_log_contents)
      message(STATUS "stdout output is:\n${out_log_contents}")
      message(STATUS "stderr output is:\n${err_log_contents}")
    endif()
    message(FATAL_ERROR "Stopping after outputting logs.")
  else()
    message(FATAL_ERROR "${msg}")
  endif()
else()
  set(msg "orc_ep configure command succeeded.  See also /home/james/CLionProjects/PQ/rawlibs/arrow-apache-arrow-2.0.0/cpp/orc_ep-prefix/src/orc_ep-stamp/orc_ep-configure-*.log")
  message(STATUS "${msg}")
endif()
