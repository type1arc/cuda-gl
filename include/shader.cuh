#pragma once

#include <GL/glew.h>

#include <cstdio>
#include <cstdlib>
#include <string>

#include "common.cuh"

class ShaderProgram
{
private:
    uint32_t m_program = 0;

    static uint32_t compile(GLenum type, const std::string& src)
    {
        uint32_t shader = glCreateShader(type);
        const char* csrc = src.c_str();
        glShaderSource(shader, 1, &csrc, nullptr);
        glCompileShader(shader);
        return shader;
    }

public:
    void load(const std::string& vert_path, const std::string& frag_path)
    {
        std::string vsrc = load_shader_src(vert_path);
        std::string fsrc = load_shader_src(frag_path);

        uint32_t vs = compile(GL_VERTEX_SHADER, vsrc);
        uint32_t fs = compile(GL_FRAGMENT_SHADER, fsrc);

        m_program = glCreateProgram();
        glAttachShader(m_program, vs);
        glAttachShader(m_program, fs);
        glLinkProgram(m_program);

        GLint link_ok = GL_FALSE;
        glGetProgramiv(m_program, GL_LINK_STATUS, &link_ok);
        if (!link_ok) {
            char log[1024];
            glGetProgramInfoLog(m_program, sizeof(log), nullptr, log);
            fprintf(stderr, "shader program link failure: %s\n", log);
            std::exit(EXIT_FAILURE);
        }

        glDeleteShader(vs);
        glDeleteShader(fs);
    }

    void use() const { glUseProgram(m_program); }
    uint32_t id() const { return m_program; }
};
