#pragma once

#include <cuda_gl_interop.h>
#include <cuda_runtime.h>

#include "common.cuh"
#include "mesh.cuh"

__global__ void particle_updater_kernel(float4* d_pos, uint32_t pw, uint32_t ph, float time)
{
    uint32_t x = blockIdx.x * blockDim.x + threadIdx.x;
    uint32_t y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= pw || y >= ph)
        return;

    float u = static_cast<float>(x) / static_cast<float>(pw) * 2.0f - 1.0f;
    float v = static_cast<float>(y) / static_cast<float>(ph) * 2.0f - 1.0f;

    float freq = 4.0f;
    float wave = sinf(u * freq + time) * cosf(v * freq + time) * 0.15f;

    uint32_t index = y * pw + x;
    d_pos[index] = make_float4(u, wave, v, 1.0f);
}

class ParticleSystem
{
private:
    Mesh* m_mesh = nullptr;
    cudaGraphicsResource* m_cuda_res = nullptr;
    dim3 m_block_dim{16, 16};
    dim3 m_grid_dim{};

public:
    void init(Mesh& mesh)
    {
        m_mesh = &mesh;
        CHK(cudaSetDevice(0));
        CHK(cudaGraphicsGLRegisterBuffer(&m_cuda_res, m_mesh->vbo(), cudaGraphicsRegisterFlagsNone));

        m_grid_dim = dim3((num_particles_x + m_block_dim.x - 1) / m_block_dim.x,
                          (num_particles_y + m_block_dim.y - 1) / m_block_dim.y);
    }

    void update(float time)
    {
        CHK(cudaGraphicsMapResources(1, &m_cuda_res, 0));
        float4* d_ptr = nullptr;
        size_t num_bytes = 0;
        CHK(cudaGraphicsResourceGetMappedPointer(reinterpret_cast<void**>(&d_ptr), &num_bytes, m_cuda_res));

        particle_updater_kernel<<<m_grid_dim, m_block_dim>>>(d_ptr, num_particles_x, num_particles_y, time);
        CHK(cudaGetLastError());
        CHK(cudaDeviceSynchronize());

        CHK(cudaGraphicsUnmapResources(1, &m_cuda_res, 0));
    }

    void draw() const { m_mesh->draw(); }

    void shutdown()
    {
        if (m_cuda_res) {
            CHK(cudaGraphicsUnregisterResource(m_cuda_res));
            m_cuda_res = nullptr;
        }
        m_mesh = nullptr;
    }
};
