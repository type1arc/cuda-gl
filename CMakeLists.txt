cmake_minimum_required(VERSION 3.24)
project(cuda-gl LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_ARCHITECTURES 89)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_RPATH "/opt/cuda/lib64")

find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)
find_package(glfw3 REQUIRED)
find_library(CUDART_LIB cudart PATHS /opt/cuda/lib64 NO_DEFAULT_PATH)

add_executable(cuda-gl src/main.cu)
target_compile_options(cuda-gl PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-Xcompiler=-Wall>)

target_link_libraries(cuda-gl PRIVATE
    ${CUDART_LIB}
    OpenGL::GL
    OpenGL::GLU
    GLEW::GLEW
    glfw
)
