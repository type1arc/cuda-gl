#version 330 core

layout (location = 0) in vec4 aPos;

void main() {
    // Combine x, y, and the wave displacement z to position the particle
    gl_Position = vec4(aPos.x, aPos.y + aPos.z, aPos.w, 1.0f);
    gl_PointSize = 2.0f;
}
