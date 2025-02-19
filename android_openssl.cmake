function(add_android_openssl_libraries)
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(ssl_root_path ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/no-asm)
  else()
    set(ssl_root_path ${CMAKE_CURRENT_FUNCTION_LIST_DIR})
  endif()

  if(Qt6_VERSION VERSION_GREATER_EQUAL 6.5.0)
    set(OPENSSL_CRYPTO_LIBRARY ${ssl_root_path}/ssl_3/${CMAKE_ANDROID_ARCH_ABI}/libcrypto_3.so)
    set(OPENSSL_SSL_LIBRARY ${ssl_root_path}/ssl_3/${CMAKE_ANDROID_ARCH_ABI}/libssl_3.so)
    set(OPENSSL_INCLUDE_DIR ${ssl_root_path}/ssl_3/include)
  else()
    set(OPENSSL_CRYPTO_LIBRARY ${ssl_root_path}/ssl_1.1/${CMAKE_ANDROID_ARCH_ABI}/libcrypto_1_1.so)
    set(OPENSSL_SSL_LIBRARY ${ssl_root_path}/ssl_1.1/${CMAKE_ANDROID_ARCH_ABI}/libssl_1_1.so)
    set(OPENSSL_INCLUDE_DIR ${ssl_root_path}/ssl_1.1/include)
  endif()

  find_package(OpenSSL REQUIRED GLOBAL)
  foreach(TARGET ${ARGN})
    if(TARGET ${TARGET})
      set_property(
        TARGET ${TARGET}
        APPEND
        PROPERTY QT_ANDROID_EXTRA_LIBS ${OPENSSL_CRYPTO_LIBRARY} ${OPENSSL_SSL_LIBRARY}
      )
      target_link_libraries(${TARGET} PUBLIC OpenSSL::SSL OpenSSL::Crypto)
    else()
      message(WARNING "Invoked add_android_openssl_libraries on a non-existing target (${TARGET}), ignoring.")
    endif()
  endforeach()
endfunction()
