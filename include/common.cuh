#pragma once

#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <cuda_runtime.h>

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>

#define CHK(expr)                                                              \
    do {                                                                       \
        cudaError_t e_ = (expr);                                               \
        if (e_ != cudaSuccess) {                                               \
            fprintf(stderr, "CUDA error %s @ %s:%d: %s\n", #expr, __FILE__,    \
                    __LINE__, cudaGetErrorString(e_));                         \
            std::exit(1);                                                      \
        }                                                                      \
    } while (0)

constexpr uint32_t w = 1200;
constexpr uint32_t h = 700;
constexpr uint32_t num_particles_x = 1024;
constexpr uint32_t num_particles_y = 1024;
constexpr uint32_t total_particles = num_particles_x * num_particles_y;

inline void glfw_error_cb(int code, const char* desc)
{
    fprintf(stderr, "GLFW error %d: %s\n", code, desc);
}

inline std::string load_shader_src(const std::string& path)
{
    std::ifstream file(path);
    if (!file.is_open())
        throw std::runtime_error(std::string("no such file or directory: ") + path);
    return std::string((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
}
