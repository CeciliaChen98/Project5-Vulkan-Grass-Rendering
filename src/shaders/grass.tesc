#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

in gl_PerVertex {
    vec4 gl_Position;
} gl_in[];

out gl_PerVertex {
    vec4 gl_Position;
} gl_out[];

layout(location = 0) in vec4[] in_v0;
layout(location = 1) in vec4[] in_v1;
layout(location = 2) in vec4[] in_v2;
layout(location = 3) in vec4[] in_up;

layout(location = 0) out vec4[] out_v0;
layout(location = 1) out vec4[] out_v1;
layout(location = 2) out vec4[] out_v2;

#define LOD 1

const float threshold = 6.0f;

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// Write any shader outputs
	out_v0[gl_InvocationID] = in_v0[gl_InvocationID];
	out_v1[gl_InvocationID] = in_v1[gl_InvocationID];
	out_v2[gl_InvocationID] = in_v2[gl_InvocationID];

# if LOD 
	vec3 cameraPos = inverse(camera.view)[3].xyz;
	vec3 up = normalize(in_up[gl_InvocationID].xyz);
	vec3 v0 = in_v0[gl_InvocationID].xyz;
    vec3 viewDir = v0- cameraPos - up * dot(v0 - cameraPos, up);
	float distance = length(viewDir);

	float level = threshold / distance;

	// Clamp level of tesselation
	level = clamp(level, 0.0, 1.0);
	float lod = level * 8.0;
# else
	float lod = 8.0;
# endif

	// Set level of tesselation
    gl_TessLevelInner[0] = lod;
	gl_TessLevelInner[1] = lod;
	gl_TessLevelOuter[0] = lod;
	gl_TessLevelOuter[1] = lod;
	gl_TessLevelOuter[2] = lod;
	gl_TessLevelOuter[3] = lod;

}
