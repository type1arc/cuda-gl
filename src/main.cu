#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <cstdlib>

#include "../include/common.cuh"
#include "../include/framework.cuh"
#include "../include/mesh.cuh"
#include "../include/particle_system.cuh"
#include "../include/shader.cuh"

int main()
{
    setenv("__NV_PRIME_RENDER_OFFLOAD", "1", 0);
    setenv("__GLX_VENDOR_LIBRARY_NAME", "nvidia", 0);

    Framework framework;
    framework.init(GLFW_PLATFORM, GLFW_PLATFORM_X11);

    ShaderProgram shader;
    shader.load("/home/typeiso/pproj/cuda-gl/shader/vertex_shader.glsl",
                "/home/typeiso/pproj/cuda-gl/shader/fragment_shader.glsl");

    Mesh mesh;
    mesh.init(total_particles);

    ParticleSystem particles;
    particles.init(mesh);

    float init_time = static_cast<float>(glfwGetTime());
    while (!framework.should_close()) {
        float curr_time = static_cast<float>(glfwGetTime() - init_time);

        particles.update(curr_time);

        glClearColor(0.03f, 0.03f, 0.03f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        shader.use();
        particles.draw();

        framework.swap_buffers();
        framework.poll_events();
    }

    particles.shutdown();
    mesh.shutdown();
    framework.shutdown();

    return EXIT_SUCCESS;
}
