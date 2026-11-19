#pragma once

#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <cstdio>
#include <cstdlib>
#include <iostream>

#include "common.cuh"

class Framework
{
private:
    GLFWwindow* m_window = nullptr;

public:
    void init(int32_t platform_type, int32_t platform_arg)
    {
        glfwSetErrorCallback(glfw_error_cb);
        glfwInitHint(platform_type, platform_arg);
        if (!glfwInit()) {
            std::cerr << "[error] [GLFW] GLFW initialization failure\n";
            std::exit(EXIT_FAILURE);
        }

        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

        m_window = glfwCreateWindow(w, h, "cuda-gl interop", nullptr, nullptr);
        if (!m_window) {
            std::cerr << "[error] window creation failure\n";
            glfwTerminate();
            std::exit(EXIT_FAILURE);
        }
        glfwMakeContextCurrent(m_window);
        glfwSwapInterval(1);

        glewExperimental = GL_TRUE;
        GLenum glew_err = glewInit();
        if (glew_err != GLEW_OK) {
            fprintf(stderr, "GLEW initialization failure: %s (code %u), GL version: %s\n",
                    glewGetErrorString(glew_err), glew_err, glGetString(GL_VERSION));
            std::exit(EXIT_FAILURE);
        }
    }

    GLFWwindow* window() const { return m_window; }

    bool should_close() const { return glfwWindowShouldClose(m_window); }
    void swap_buffers() const { glfwSwapBuffers(m_window); }
    void poll_events() const { glfwPollEvents(); }

    void shutdown() const { glfwTerminate(); }
};
