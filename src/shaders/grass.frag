#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec3 fs_nor;
layout(location = 1) in float fs_v;

layout(location = 0) out vec4 outColor;

float hash(float n) {
    return fract(sin(n * 17.54321) * 43758.5453);
}

void main() {
    vec3 N = normalize(fs_nor);

    vec3 lightDir = normalize(vec3(0.3, 0.8, 0.5));
    float diff = max(dot(N, lightDir), 0.0);

    // default colors for grass
    vec3 baseColor = vec3(49, 125, 54) / 255;
    vec3 tipColor  = vec3(162, 214, 124) / 255.;

    vec3 grassColor = mix(baseColor, tipColor, fs_v);

    vec3 ambient = vec3(0.1, 0.15, 0.1);
    vec3 color = ambient + grassColor * (0.7 + 0.2 * diff);

    outColor = vec4(color, 1.0);
}
