#pragma once

#include <GL/glew.h>
#include <cuda_runtime.h>

#include <cstdint>

class Mesh
{
private:
    GLuint m_vbo = 0;
    GLuint m_vao = 0;
    uint32_t m_vertex_count = 0;

public:
    void init(uint32_t vertex_count)
    {
        m_vertex_count = vertex_count;

        glGenBuffers(1, &m_vbo);
        glBindBuffer(GL_ARRAY_BUFFER, m_vbo);
        glBufferData(GL_ARRAY_BUFFER, static_cast<size_t>(m_vertex_count) * sizeof(float4), nullptr, GL_DYNAMIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);

        glGenVertexArrays(1, &m_vao);
        glBindVertexArray(m_vao);
        glBindBuffer(GL_ARRAY_BUFFER, m_vbo);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(float), reinterpret_cast<void*>(0));
        glBindVertexArray(0);
    }

    void draw() const
    {
        glBindVertexArray(m_vao);
        glDrawArrays(GL_POINTS, 0, m_vertex_count);
        glBindVertexArray(0);
    }

    GLuint vbo() const { return m_vbo; }
    uint32_t vertex_count() const { return m_vertex_count; }

    void shutdown()
    {
        if (m_vbo) {
            glDeleteBuffers(1, &m_vbo);
            m_vbo = 0;
        }
        if (m_vao) {
            glDeleteVertexArrays(1, &m_vao);
            m_vao = 0;
        }
    }
};
