//
// Generated by Microsoft (R) D3DX9 Shader Compiler
//
// Parameters:
//
//   float4 cFlashlightColor;
//   float4 cGlobalLightAmbientColor1;
//   float4 cGlobalLightAmbientColor2;
//   float4 cGlobalLightAmbientLightVector;
//   float4 cLightScale;
//   float4 g_FlashlightAttenuationFactors;
//   float3 g_FlashlightPos;
//   float4 g_LinearFogColor;
//   float4 g_Spec_Rim_EnvIntensity;
//   float4 g_cDetail1Tint;
//   float4 g_diffuseModulation;
//   sampler2D g_tBase;
//   sampler2D g_tDetail1;
//   sampler2D g_tDetail2;
//   sampler2D g_tFlashlight;
//   sampler2D g_tFresnelWarp;
//   sampler2D g_tMaskMap1;
//   sampler2D g_tMaskMap2;
//   sampler2D g_tNormal;
//   sampler2D g_tShadowDepth;
//   float4 g_vBlendFullFx1;
//   float4 g_vBlendFullFx2;
//   float4 g_vEyePos_SpecExp;
//   float4 g_vFXIntensities;
//   float4 g_vSpecularColor_Scale;
//
//
// Registers:
//
//   Name                           Reg   Size
//   ------------------------------ ----- ----
//   g_vSpecularColor_Scale         c0       1
//   g_Spec_Rim_EnvIntensity        g_Spec_Rim_EnvIntensity       1
//   g_diffuseModulation            g_diffuseModulation       1
//   g_vFXIntensities               g_vFXIntensities       1
//   g_vEyePos_SpecExp              g_vEyePos_SpecExp       1
//   g_FlashlightAttenuationFactors g_FlashlightAttenuationFactors       1
//   g_FlashlightPos                g_FlashlightPos       1
//   g_cDetail1Tint                 g_cDetail1Tint       1
//   cGlobalLightAmbientColor1      cGlobalLightAmbientColor1      1
//   cGlobalLightAmbientColor2      cGlobalLightAmbientColor2      1
//   cGlobalLightAmbientLightVector cGlobalLightAmbientLightVector      1
//   g_vBlendFullFx1                g_vBlendFullFx1      1
//   g_vBlendFullFx2                g_vBlendFullFx2      1
//   cFlashlightColor               cFlashlightColor      1
//   g_LinearFogColor               g_LinearFogColor      1
//   cLightScale                    cLightScale      1
//   g_tBase                        g_tBase       1
//   g_tNormal                      g_tNormal       1
//   g_tDetail2                     g_tDetail2       1
//   g_tMaskMap1                    g_tMaskMap1       1
//   g_tMaskMap2                    g_tMaskMap2       1
//   g_tDetail1                     g_tDetail1       1
//   g_tFresnelWarp                 g_tFresnelWarp      1
//   g_tFlashlight                  g_tFlashlight      1
//   g_tShadowDepth                 g_tShadowDepth      1
//

// Pixel Shader 3.0

void main() {
    vec4 c5(0.0749063641, 0.123595506, 0.205992505, -20000);
    vec4 c9(0.0009765625, 0, 1, -0.0009765625);
    vec4 c10(2, -1, 0.5, -0);
    vec4 c11(-0.00999999978, 0.00999999978, 0, 0);
    Sampler2D g_tBase;
    Sampler2D g_tNormal;
    Sampler2D g_tDetail2;
    Sampler2D g_tMaskMap1;
    Sampler2D g_tMaskMap2;
    Sampler2D g_tDetail1;
    Sampler2D g_tFresnelWarp;
    Sampler2D g_tFlashlight;
    Sampler2D g_tShadowDepth;
    r0.x = abs(g_vEyePos_SpecExp.w);
    r0.y = g_LinearFogColor.w * v4.w;
    r1 = texture2D(g_tBase, vTexCoord);
    r0.z = r1.w * g_diffuseModulation.w;
    oC0.w = -r0.x >= 0 ? r0.z : r0.y;
    r0 = -c10.yyyw * v8.xyzx;
    r2 = r0 + c9.xxyz;
    r2 = texture2D(g_tShadowDepth, r2/r2.w);
    r3 = r0 + c9.wxyz;
    r3 = texture2D(g_tShadowDepth, r3/r3.w);
    r2.y = r3.x;
    r3 = r0 + c9.xwyz;
    r3 = texture2D(g_tShadowDepth, r3/r3.w);
    r2.z = r3.x;
    r3 = r0 + c9.wwyz;
    r3 = texture2D(g_tShadowDepth, r3/r3.w);
    r2.w = r3.x;
    r1.w = dot(r2, c5.x);
    r2 = r0 + c9.xyyz;
    r2 = texture2D(g_tShadowDepth, r2/r2.w);
    r3 = r0 + c9.wyyz;
    r3 = texture2D(g_tShadowDepth, r3/r3.w);
    r2.y = r3.x;
    r3 = r0 + c9.ywyz;
    r3 = texture2D(g_tShadowDepth, r3/r3.w);
    r2.z = r3.x;
    r3 = r0 + c9.yxyz;
    r0 = r0 - c10.wwwy;
    r3 = texture2D(g_tShadowDepth, r3/r3.w);
    r2.w = r3.x;
    r2.x = dot(r2, c5.y);
    r1.w = r1.w + r2.x;
    r0 = texture2D(g_tShadowDepth, r0/r0.w);
    r0.x = r0.x * c5.z + r1.w;
    r0.y = c5.w + v4.z;
    r0.z = 1/g_FlashlightPos.z;
    r0.y = -r0.y * r0.z;
    r0.yz = g_FlashlightPos.xxyw * r0.y + v4.xxyw;
    r0.w = 1/cGlobalLightAmbientLightVector.w;
    r2.xy = r0.yzzw * r0.w + g_FlashlightAttenuationFactors;
    r0.yz = r0 * r0.w + g_FlashlightAttenuationFactors.xzww;
    r2 = texture2D(g_tFlashlight, r2);
    r3 = texture2D(g_tFlashlight, r0.yzzw);
    r0.y = r2.x * r3.y;
    r0.z = r2.x * -r3.y - c10.y;
    r2.xyz = r0.y * cFlashlightColor;
    r2.xyz = r0.x * r2;
    r0.y = -c10.y - r0.x;
    r1.w = max(r0.y, r0.z);
    r0.yzw = r1.w * cGlobalLightAmbientColor2.xxyz;
    r0.yzw = r0 * v1.x;
    r3 = texture2D(g_tNormal, vTexCoord);
    r3.xyz = r3 * c10.x + c10.y;
    r4.xyz = normalize(r3);
    r3.xyz = r4.y * v6;
    r3.xyz = r4.x * v5 + r3;
    r3.xyz = r4.z * v7 + r3;
    r4.xyz = normalize(r3);
    r1.w = dot(cGlobalLightAmbientLightVector.xyz, r4.xyz) // CLAMPED;
    r3.xyz = r1.w * cGlobalLightAmbientColor1;
    r0.yzw = r3.xxyz * v1.x + r0;
    r1.w = -v8.w >= 0 ? -c10.w : -c10.y;
    r0.x = r0.x * r1.w;
    r3.xyz = normalize(-g_FlashlightPos);
    r1.w = dot(r4.xyz, r3.xyz);
    r2.w = r1.w * c10.z + c10.z;
    r1.w = clamp(r1.w, 0, 1);
    r0.x = r0.x * r2.w;
    r0.xyz = r0.x * r2 + r0.yzww;
    r5.xyz = normalize(vTexCoord2);
    r6.x = dot(r5.xyz, r4.xyz);
    r0.w = r6.x + r6.x;
    r6.x = r6.x // CLAMPED;
    r4.xyw = r4.xyzz * -r0.w + r5.xyzz;
    r0.w = max(r4.z, -c10.w);
    r2.w = dot(r3.xyz, -r4.xyww.xyz) // CLAMPED;
    r3.x = r2.w + c11.x;
    r2.w = r3.x >= 0 ? r2.w : c11.y // CLAMPED;
    r3 = texture2D(g_tMaskMap2, vTexCoord);
    r4 = max(r3, g_vBlendFullFx2);
    r3.x = r4.w * g_Spec_Rim_EnvIntensity.x;
    r4.w = pow(r2.w, r3.x);
    r1.w *= r4.w;
    r2.xyz = r2 * r1.w;
    r2.xyz = r2 * g_vSpecularColor_Scale.w;
    r2.xyz = r4.x * r2;
    r3.xyz = mix(g_vSpecularColor_Scale, r1, r4.z);
    r4.xyz = r4.y * vTexCoord3;
    r2.xyz = r2 * r3;
    r6.y = c10.z;
    FresnelWarpColor = texture2D(g_tFresnelWarp, r6);

    vec4 Mask1Val = texture2D(g_tMaskMap1, vTexCoord);
    Mask1Val.xyz = max(Mask1Val.xzww, g_vBlendFullFx1.xzww);

    float detailIntensity = Mask1Val.x;
    float metalness = Mask1Val.y;
    float selfIllum = Mask1Val.z;

    r1.w = max(FresnelWarpColor.z, metalness);
    r3.yzw = r2.xxyz * r1.w;

    vec4 detailColor = texture2D(g_tDetail1, vec2(v1.w, v2.w));
    detailColor.xyz = detailColor * g_cDetail1Tint;

    detailIntensity *= g_vFXIntensities.z;
    r1.xyz += detailColor * detailIntensity; // r1 = Base Texture!
    selfIllum = clamp(detailColor.a * detailIntensity + selfIllum, 0, 1);

    vec4 detail2Color = texture2D(g_tDetail2, v0.zwzw);
    r1.xyz = detail2Color * g_vFXIntensities.w + r1;
    r0.xyz = r0 * r1 + r3.yzww;
    r2.xyz = r2 * r1.w - r0;
    r0.xyz = metalness * r2 + r0;
    r2.xyz = r0.w * r4;
    r0.xyz = r2 * FresnelWarpColor.x + r0;

    r3.xyz = mix(r1, r0, selfIllum);
    r0.xyz = r3 * cLightScale.x;
    r1.x = cLightScale.x;
    r1.xyz = r3 * -r1.x + g_LinearFogColor;
    r0.w = v3.w * v3.w;
    oC0.xyz = r0.w * r1 + r0
}
// approximately 125 instruction slots used (18 texture, 107 arithmetic)
