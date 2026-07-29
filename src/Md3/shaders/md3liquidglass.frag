#version 440

// Liquid Glass — aligned with open recreations (kennsorr / glass-gl / ybouane):
// 1) Snell's Law surfaceSlope (flat centre, steep rim)
// 2) Subtle R/G/B IOR dispersion
// 3) Multi-tap frost
// 4) White Fresnel rim + directional specular
// Plus SDF merge for multi-body fusion.
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

// Circular-arc surface slope (Ken Sorrell / Snell's Law lens profile).
// t=0 at rim (steep), t=1 toward centre (flat).
float surfaceSlope(float t)
{
    float cl = clamp(t, 0.001, 0.999);
    return (1.0 - cl) / max(sqrt(1.0 - (1.0 - cl) * (1.0 - cl)), 0.001);
}

vec2 refractCardUv(vec2 uv, float ior)
{
    if (bend < 0.001)
        return uv;

    float d = fusedField(uv);
    float bevelWidth = max(0.04, radiusNorm * (0.85 + 0.55 * thickness));
    // inset: 0 at rim, 1 deep inside — matches Ken's edgeDist / t
    float inset = clamp(-d / bevelWidth, 0.0, 1.0);
    float slope = surfaceSlope(inset);

    vec2 grad = sdfGradient(uv);
    vec2 dir = grad;
    if (length(dir) < 1e-4) {
        vec2 p = (uv - 0.5) * vec2(aspect, 1.0);
        dir = length(p) > 1e-4 ? normalize(p) : vec2(0.0);
    }

    // Map bend (~1.2) → IOR ≈ 1.5 like real glass / kennsorr default.
    float n = max(1.05, 1.0 + bend * 0.42 * ior);
    float rApprox = min(aspect, 1.0) * 0.5;
    float bevelFrac = clamp(bevelWidth / max(rApprox, 0.02), 0.15, 0.85);
    // Snell small-angle: slope * (1 - 1/n) * r * bevel * 0.5
    float amount = slope * (1.0 - 1.0 / n) * rApprox * bevelFrac * 0.55;
    amount *= (0.9 + 0.2 * thickness);

    vec2 offset = dir * amount;
    offset.x /= max(aspect, 0.001);
    return uv - offset;
}

vec4 sampleFrost(vec2 texUv, float edgeFactor)
{
    // Slightly less frost at the rim so refraction stays sharp (kennsorr).
    float spread = frost * (0.7 + 0.5 * thickness) * (1.0 - edgeFactor * 0.3);
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
    vec2 uv = qt_TexCoord0;
    float d = fusedField(uv);
    float bevelWidth = max(0.04, radiusNorm * (0.85 + 0.55 * thickness));
    float inset = clamp(-d / bevelWidth, 0.0, 1.0);
    float edgeFactor = 1.0 - inset;

    // Open-source chroma is tiny: kennsorr uses ior ± dispersion*0.02.
    // Our chroma slider 0..1 → dispersion 0..2 equivalent.
    float useChroma = (quality >= 0.5) ? chroma : 0.0;
    float disp = useChroma * 2.0;

    float r, g, b;
    if (disp < 0.05) {
        vec4 c = sampleFrost(cardToTex(refractCardUv(uv, 1.0)), edgeFactor);
        r = c.r; g = c.g; b = c.b;
    } else {
        float iorR = 1.0 - disp * 0.02;
        float iorG = 1.0;
        float iorB = 1.0 + disp * 0.02;
        r = sampleFrost(cardToTex(refractCardUv(uv, iorR)), edgeFactor).r;
        g = sampleFrost(cardToTex(refractCardUv(uv, iorG)), edgeFactor).g;
        b = sampleFrost(cardToTex(refractCardUv(uv, iorB)), edgeFactor).b;
    }

    vec3 col = vec3(r, g, b);

    // Vibrancy (kennsorr 1.15 / glass-gl saturation ~1.2)
    float luma = dot(col, vec3(0.299, 0.587, 0.114));
    col = mix(vec3(luma), col, 1.12);

    // Adaptive tint from local luminance (first-version behaviour).
    float lift = (1.0 - luma) * adaptive * (0.14 + baseTint);
    float veil = luma * adaptive * (0.08 + baseTint * 0.5);
    float body = baseTint * (0.55 + 0.35 * thickness);
    col += vec3(lift - veil) + body * vec3((1.0 - luma) * 0.15, (1.0 - luma) * 0.15, (1.0 - luma) * 0.12);

    // Subtle ambient spill (keep low — heavy scene mix muddied earlier looks).
    if (sceneColor > 0.01) {
        vec3 spill = texture(source, cardToTex(uv)).rgb;
        col = mix(col, mix(col, spill, 0.22), clamp(sceneColor, 0.0, 1.0));
    }

    // White Fresnel rim + specular (kennsorr Layer 4) — not coloured scene glow.
    vec2 grad = sdfGradient(uv);
    vec2 lightDir = normalize(vec2(-0.32, -0.72));
    float rim = pow(max(edgeFactor, 0.0), 2.5) * 0.4;
    float spec = pow(max(dot(normalize(grad + vec2(1e-4)), lightDir), 0.0), 8.0) * edgeFactor;
    float spectral = clamp(edgeSpectral, 0.0, 2.0);
    col += vec3(spec * 0.5 + rim) * spectral;

    // Slight centre dim so the rim reads as thicker glass.
    col *= 1.0 - (1.0 - edgeFactor) * 0.05;
    col = clamp(col, 0.0, 1.0);

    fragColor = vec4(col, 1.0) * qt_Opacity;
}
