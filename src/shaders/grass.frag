#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec3 fs_nor;

layout(location = 0) out vec4 outColor;

void main() {
    vec3 N = normalize(fs_nor);

    // simple directional light
    vec3 L = normalize(vec3(0.3, 0.8, 0.4));
    float diff = max(dot(N, L), 0.0);

    // base color of grass
    vec3 grassColor = vec3(0.1, 0.6, 0.1);

    // simple shading
    vec3 color = grassColor * (0.2 + 0.8 * diff);

    outColor = vec4(color, 1.0);
}
