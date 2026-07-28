#version 440

// Liquid Glass lens: edge refraction, chromatic fringe, light frost.
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float bend;
    float frost;
    float chroma;
    float radiusNorm;
    float aspect;
    float padU;
    float padV;
};

layout(binding = 1) uniform sampler2D source;

float sdRoundBox(vec2 p, vec2 b, float r)
{
    vec2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

// Card UV 0..1 → padded texture UV (inner rect).
vec2 cardToTex(vec2 uv)
{
    return vec2(mix(padU, 1.0 - padU, uv.x),
                mix(padV, 1.0 - padV, uv.y));
}

vec2 refractCardUv(vec2 uv, float iorScale)
{
    vec2 p = (uv - 0.5) * vec2(aspect, 1.0);
    vec2 halfSize = 0.5 * vec2(aspect, 1.0);
    float r = radiusNorm * min(aspect, 1.0);
    float d = sdRoundBox(p, halfSize, r);
    float inset = clamp(-d / max(r * 1.35, 0.04), 0.0, 1.0);
    float bevel = pow(1.0 - inset, 1.65);
    vec2 dir = length(p) > 1e-4 ? normalize(p) : vec2(0.0);
    float amount = bevel * bend * iorScale * 0.22;
    vec2 offset = dir * amount;
    offset.x /= max(aspect, 0.001);
    return uv - offset;
}

vec4 sampleFrost(vec2 texUv)
{
    if (frost < 0.0005)
        return texture(source, texUv);

    vec4 acc = texture(source, texUv) * 2.0;
    const int taps = 8;
    for (int i = 0; i < taps; ++i) {
        float a = float(i) * 6.2831853 / float(taps);
        vec2 o = vec2(cos(a), sin(a)) * frost;
        o.x /= max(aspect, 0.001);
        // Scale offset into padded texture space.
        o.x *= (1.0 - 2.0 * padU);
        o.y *= (1.0 - 2.0 * padV);
        acc += texture(source, clamp(texUv + o, 0.001, 0.999));
    }
    return acc / (2.0 + float(taps));
}

void main()
{
    float iorR = 1.0 - chroma * 0.35;
    float iorG = 1.0;
    float iorB = 1.0 + chroma * 0.35;

    vec2 uvR = refractCardUv(qt_TexCoord0, iorR);
    vec2 uvG = refractCardUv(qt_TexCoord0, iorG);
    vec2 uvB = refractCardUv(qt_TexCoord0, iorB);

    float r = sampleFrost(cardToTex(uvR)).r;
    float g = sampleFrost(cardToTex(uvG)).g;
    float b = sampleFrost(cardToTex(uvB)).b;

    fragColor = vec4(r, g, b, 1.0) * qt_Opacity;
}
