#version 440

// Squircle alpha mask for Liquid Glass (n≈4–5 ≈ Apple continuous corner).
// MultiEffect reads the ALPHA channel — keep RGB white, put coverage in A.
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float aspect;
    float squircleN;
    float soft;
};

void main()
{
    vec2 p = (qt_TexCoord0 - vec2(0.5)) * 2.0;
    p.x *= max(aspect, 1e-4);
    // Unit squircle in the same space as p (half-extents = aspect × 1).
    vec2 b = vec2(max(aspect, 1e-4), 1.0);
    vec2 d = abs(p) / b;
    float v = pow(pow(d.x, squircleN) + pow(d.y, squircleN), 1.0 / squircleN);
    float edge = v - 1.0;
    float a = 1.0 - smoothstep(-soft, soft, edge);
    fragColor = vec4(1.0, 1.0, 1.0, a) * qt_Opacity;
}
