#version 440

// Alpha mask sharing the same fused SDF as the liquid-glass lens.
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float aspect;
    float squircleN;
    float soft;
    float fusion;
    float fusionK;
    vec4 mergeA;
    vec4 mergeB;
    vec4 dropA;
    vec4 dropB;
    vec4 dropC;
};

float sdSquircle(vec2 p, vec2 b, float n)
{
    vec2 d = abs(p) / max(b, vec2(1e-4));
    float v = pow(pow(d.x, n) + pow(d.y, n), 1.0 / n);
    return (v - 1.0) * min(b.x, b.y);
}

float sdBody(vec2 uv, vec4 body)
{
    if (body.z <= 0.001)
        return 1e3;
    vec2 p = (uv - body.xy) * vec2(aspect, 1.0);
    vec2 halfSize = body.zw * vec2(aspect, 1.0);
    return sdSquircle(p, halfSize, squircleN);
}

float sdCircleUv(vec2 uv, vec4 droplet)
{
    if (droplet.w <= 0.001 || droplet.z <= 0.001)
        return 1e3;
    vec2 p = (uv - droplet.xy) * vec2(aspect, 1.0);
    float r = droplet.z * max(aspect, 1.0);
    return length(p) - r;
}

float smin(float a, float b, float k)
{
    float h = clamp(0.5 + 0.5 * (b - a) / max(k, 1e-5), 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

float fusedField(vec2 uv)
{
    float d = sdBody(uv, mergeA);
    if (mergeB.z > 0.001)
        d = smin(d, sdBody(uv, mergeB), fusionK);
    if (fusion < 0.01)
        return d;

    float k = (0.04 + 0.10 * fusion) * min(aspect, 1.0);
    d = smin(d, sdCircleUv(uv, dropA), k);
    d = smin(d, sdCircleUv(uv, dropB), k);
    d = smin(d, sdCircleUv(uv, dropC), k);
    return d;
}

void main()
{
    float d = fusedField(qt_TexCoord0);
    float a = 1.0 - smoothstep(-soft, soft, d);
    fragColor = vec4(1.0, 1.0, 1.0, a) * qt_Opacity;
}
