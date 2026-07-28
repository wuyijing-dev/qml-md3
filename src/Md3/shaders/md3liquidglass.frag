#version 440

// Liquid Glass: regional sample, squircle lens, adaptive tint.
// quality: 0=low (1 sample), 1=medium (4 frost taps), 2=high (8 taps + chroma)
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
    float squircleN;
    float thickness;
    float adaptive;
    float baseTint;
    float quality;
};

layout(binding = 1) uniform sampler2D source;

float sdSquircle(vec2 p, vec2 b, float n)
{
    vec2 d = abs(p) / max(b, vec2(1e-4));
    float v = pow(pow(d.x, n) + pow(d.y, n), 1.0 / n);
    return (v - 1.0) * min(b.x, b.y);
}

vec2 cardToTex(vec2 uv)
{
    return vec2(mix(padU, 1.0 - padU, uv.x),
                mix(padV, 1.0 - padV, uv.y));
}

vec2 refractCardUv(vec2 uv, float iorScale)
{
    if (bend < 0.001)
        return uv;
    vec2 p = (uv - 0.5) * vec2(aspect, 1.0);
    vec2 halfSize = 0.5 * vec2(aspect, 1.0);
    float d = sdSquircle(p, halfSize, squircleN);
    float bevelWidth = max(0.04, radiusNorm * (0.85 + 0.55 * thickness));
    float inset = clamp(-d / bevelWidth, 0.0, 1.0);
    float bevel = pow(1.0 - inset, 1.55);
    vec2 dir = length(p) > 1e-4 ? normalize(p) : vec2(0.0);
    float amount = bevel * bend * iorScale * (0.16 + 0.12 * thickness);
    vec2 offset = dir * amount;
    offset.x /= max(aspect, 0.001);
    return uv - offset;
}

vec4 sampleFrost(vec2 texUv)
{
    float spread = frost * (0.7 + 0.5 * thickness);
    if (spread < 0.0005 || quality < 0.5)
        return texture(source, texUv);

    vec4 acc = texture(source, texUv) * 2.0;
    int taps = quality > 1.5 ? 8 : 4;
    for (int i = 0; i < 8; ++i) {
        if (i >= taps)
            break;
        float a = float(i) * 6.2831853 / float(taps);
        vec2 o = vec2(cos(a), sin(a)) * spread;
        o.x /= max(aspect, 0.001);
        o.x *= (1.0 - 2.0 * padU);
        o.y *= (1.0 - 2.0 * padV);
        acc += texture(source, clamp(texUv + o, 0.001, 0.999));
    }
    return acc / (2.0 + float(taps));
}

void main()
{
    float r, g, b;
    if (chroma < 0.02 || quality < 0.5) {
        vec4 c = sampleFrost(cardToTex(refractCardUv(qt_TexCoord0, 1.0)));
        r = c.r; g = c.g; b = c.b;
    } else {
        float iorR = 1.0 - chroma * 0.35;
        float iorG = 1.0;
        float iorB = 1.0 + chroma * 0.35;
        r = sampleFrost(cardToTex(refractCardUv(qt_TexCoord0, iorR))).r;
        g = sampleFrost(cardToTex(refractCardUv(qt_TexCoord0, iorG))).g;
        b = sampleFrost(cardToTex(refractCardUv(qt_TexCoord0, iorB))).b;
    }

    float lum = dot(vec3(r, g, b), vec3(0.299, 0.587, 0.114));
    float lift = (1.0 - lum) * adaptive * (0.14 + baseTint);
    float veil = lum * adaptive * (0.08 + baseTint * 0.5);
    float body = baseTint * (0.55 + 0.35 * thickness);
    r = clamp(r + lift - veil + body * (1.0 - lum) * 0.15, 0.0, 1.0);
    g = clamp(g + lift - veil + body * (1.0 - lum) * 0.15, 0.0, 1.0);
    b = clamp(b + lift - veil + body * (1.0 - lum) * 0.12, 0.0, 1.0);

    fragColor = vec4(r, g, b, 1.0) * qt_Opacity;
}
