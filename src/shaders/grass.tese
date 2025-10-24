#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

struct Blade {
    vec4 v0;
    vec4 v1;
    vec4 v2;
    vec4 up;
};

layout(set = 0, binding = 1, std430) readonly  buffer InBlades {
    Blade blades[];
};

vec3 bezier(vec3 p0, vec3 p1, vec3 p2, float t) {
    // De Casteljau
    vec3 a = mix(p0, p1, t);
    vec3 b = mix(p1, p2, t);
    return mix(a, b, t);
}
// TODO: Declare tessellation evaluation shader inputs and outputs


void main() {

    const uint idx = gl_GlobalInvocationID.x;
    Blade b = blades[idx]; 

    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
    float orientation = b.v0.w;
    float height = b.v1.w;
    float width = b.v2.w;

    vec3 up = b.up.xyz;
    vec3 v0 = b.v0.xyz;
    vec3 v1 = b.v1.xyz;
    vec3 v2 = b.v2.xyz;

    vec3 pos = bezier(v0, v1, v2, u);
    vec3 derivative = 2.0 * (mix(p1 - p0, p2 - p1, v));
    vec3 widthDir = normalize(cross(upN, front));


}
