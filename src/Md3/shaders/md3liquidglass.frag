#version 440

// Liquid Glass: regional sample, squircle lens, SDF merge, adaptive tint.
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
    float fusion;
    float fusionK;
    vec4 mergeA;
    vec4 mergeB;
    vec4 dropA;
    vec4 dropB;
    vec4 dropC;
    float edgeSpectral;
    float sceneColor;
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

vec2 sdfGradient(vec2 uv)
{
    float e = 0.0035;
    float dx = fusedField(uv + vec2(e, 0.0)) - fusedField(uv - vec2(e, 0.0));
    float dy = fusedField(uv + vec2(0.0, e)) - fusedField(uv - vec2(0.0, e));
    vec2 g = vec2(dx, dy) / max(e * 2.0, 1e-5);
    return length(g) > 1e-4 ? normalize(g) : vec2(0.0);
}

vec2 refractCardUv(vec2 uv, float iorScale)
{
    if (bend < 0.001)
        return uv;
    vec2 grad = sdfGradient(uv);
    float d = fusedField(uv);
    float bevelWidth = max(0.035, radiusNorm * (0.85 + 0.55 * thickness));
    float inset = clamp(-d / bevelWidth, 0.0, 1.0);
    float bevel = pow(1.0 - inset, 1.45);
    vec2 dir = grad;
    if (length(dir) < 1e-4) {
        vec2 p = (uv - 0.5) * vec2(aspect, 1.0);
        dir = length(p) > 1e-4 ? normalize(p) : vec2(0.0);
    }
    // Convex lens: strongest warp at the rim (Apple Liquid Glass reads as a domed lens).
    float amount = bevel * bevel * bend * iorScale * (0.28 + 0.22 * thickness);
    vec2 offset = dir * amount;
    offset.x /= max(aspect, 0.001);
    return uv - offset;
}

vec4 sampleFrost(vec2 texUv)
{
    float spread = frost * (0.55 + 0.45 * thickness);
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

vec3 sampleSceneAverage(vec2 texUv)
{
    vec2 e = vec2((1.0 - 2.0 * padU), (1.0 - 2.0 * padV));
    vec2 ox = vec2(0.10 * e.x, 0.0);
    vec2 oy = vec2(0.0, 0.10 * e.y);
    vec3 c = texture(source, clamp(texUv, 0.001, 0.999)).rgb;
    c += texture(source, clamp(texUv + ox, 0.001, 0.999)).rgb;
    c += texture(source, clamp(texUv - ox, 0.001, 0.999)).rgb;
    c += texture(source, clamp(texUv + oy, 0.001, 0.999)).rgb;
    c += texture(source, clamp(texUv - oy, 0.001, 0.999)).rgb;
    return c / 5.0;
}

void main()
{
    vec2 uv = qt_TexCoord0;
    float d = fusedField(uv);
    float bevelWidth = max(0.035, radiusNorm * (0.85 + 0.55 * thickness));
    float edgeBand = 1.0 - smoothstep(0.0, bevelWidth * 1.35, abs(d));
    float rimMask = 1.0 - smoothstep(0.0, bevelWidth * 1.05, max(-d, 0.0));
    float chromaEdge = chroma * rimMask * (quality >= 0.5 ? 1.0 : 0.0);

    float r, g, b;
    if (chromaEdge < 0.02) {
        vec4 c = sampleFrost(cardToTex(refractCardUv(uv, 1.0)));
        r = c.r; g = c.g; b = c.b;
    } else {
        float iorR = 1.0 - chromaEdge * 0.55;
        float iorG = 1.0;
        float iorB = 1.0 + chromaEdge * 0.55;
        r = sampleFrost(cardToTex(refractCardUv(uv, iorR))).r;
        g = sampleFrost(cardToTex(refractCardUv(uv, iorG))).g;
        b = sampleFrost(cardToTex(refractCardUv(uv, iorB))).b;
    }
    vec2 grad = sdfGradient(uv);
    vec2 rimOffset = grad * (0.025 + 0.02 * bend);
    rimOffset.x /= max(aspect, 0.001);
    vec2 rimUv = clamp(cardToTex(uv + rimOffset), 0.001, 0.999);
    vec3 rimScene = texture(source, rimUv).rgb;
    float rimLum = dot(rimScene, vec3(0.299, 0.587, 0.114));
    float fresnel = pow(clamp(edgeBand, 0.0, 1.0), 0.55);
    vec3 lightDir = normalize(vec3(-0.32, -0.48, 0.82));
    vec3 nrm = vec3(grad * rimMask, sqrt(max(0.02, 1.0 - rimMask * rimMask)));
    float spec = pow(max(dot(nrm, lightDir), 0.0), 28.0) * rimMask;

    float lum = dot(vec3(r, g, b), vec3(0.299, 0.587, 0.114));
    float lift = (1.0 - lum) * adaptive * (0.08 + baseTint * 0.5);
    float veil = lum * adaptive * (0.04 + baseTint * 0.25);
    float body = baseTint * (0.25 + 0.2 * thickness);
    vec3 sceneAvg = sampleSceneAverage(cardToTex(uv));
    vec3 col = vec3(r, g, b);
    col += vec3(lift - veil) + body * vec3((1.0 - lum) * 0.08);
    col = mix(col, mix(col, sceneAvg, 0.35), clamp(sceneColor, 0.0, 1.0));

    float spectral = clamp(edgeSpectral, 0.0, 2.5);
    vec3 rimGlow = rimScene * (0.65 + rimLum * 0.55);
    col += rimGlow * fresnel * spectral * (0.32 + 0.22 * bend);
    col += vec3(1.0) * fresnel * spectral * 0.11;
    col += vec3(1.0) * spec * (0.35 + 0.25 * bend);
    col *= 1.0 - rimMask * 0.04;
    col = clamp(col, 0.0, 1.0);

    fragColor = vec4(col, 1.0) * qt_Opacity;
}
