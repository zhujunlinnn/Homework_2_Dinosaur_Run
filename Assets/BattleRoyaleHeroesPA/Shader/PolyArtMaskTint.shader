Shader "PolyArtMaskTint_URP"
{
    Properties
    {
        _PolyArtAlbedo("PolyArtAlbedo", 2D) = "white" {}
        _Mask01("Mask01", 2D) = "white" {}
        _Mask02("Mask02", 2D) = "white" {}
        _Emission("Emission", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0
        _Metallic("Metallic", Range(0, 1)) = 0
        _Color01("Color01", Color) = (0.7205882,0.08477508,0.08477508,0)
        _Color02("Color02", Color) = (0.02649222,0.3602941,0.09785674,0)
        _Color03("Color03", Color) = (0.07628676,0.2567445,0.6102941,0)
        _Color04("Color04", Color) = (0.6207737,0.1119702,0.8014706,0)
        _Color05("Color05", Color) = (0.9056604,0.5051349,0.09825563,0)
        _Color06("Color06", Color) = (1,0.7848822,0,0)
        [HDR]_EmissionColor("EmissionColor", Color) = (1,0.6413792,0,0)
        _EmissionPower("EmissionPower", Range(0, 4)) = 1
        _Color01Power("Color01Power", Range(0, 6)) = 1
        _Color02Power("Color02Power", Range(0, 6)) = 1
        _Color03Power("Color03Power", Range(0, 6)) = 1
        _Color04Power("Color04Power", Range(0, 6)) = 1
        _Color05Power("Color05Power", Range(0, 6)) = 1
        _Color06Power("Color06Power", Range(0, 6)) = 1
        [HideInInspector] _texcoord("", 2D) = "white" {}
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
            "UniversalMaterialType" = "Lit"
            "IgnoreProjector" = "True"
        }
        
        LOD 300

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }
            
            Cull Back
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            // URP keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fog
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                half fogCoord : TEXCOORD3;
            };

            TEXTURE2D(_PolyArtAlbedo);
            SAMPLER(sampler_PolyArtAlbedo);
            TEXTURE2D(_Mask01);
            SAMPLER(sampler_Mask01);
            TEXTURE2D(_Mask02);
            SAMPLER(sampler_Mask02);
            TEXTURE2D(_Emission);
            SAMPLER(sampler_Emission);
            
            CBUFFER_START(UnityPerMaterial)
            float4 _PolyArtAlbedo_ST;
            float4 _Mask01_ST;
            float4 _Mask02_ST;
            float4 _Emission_ST;
            float4 _Color01;
            float4 _Color02;
            float4 _Color03;
            float4 _Color04;
            float4 _Color05;
            float4 _Color06;
            float4 _EmissionColor;
            float _Smoothness;
            float _Metallic;
            float _EmissionPower;
            float _Color01Power;
            float _Color02Power;
            float _Color03Power;
            float _Color04Power;
            float _Color05Power;
            float _Color06Power;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;
                
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS);
                
                output.positionCS = vertexInput.positionCS;
                output.positionWS = vertexInput.positionWS;
                output.normalWS = normalInput.normalWS;
                output.uv = TRANSFORM_TEX(input.uv, _PolyArtAlbedo);
                output.fogCoord = ComputeFogFactor(vertexInput.positionCS.z);
                
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                // 采样纹理
                half4 tex2DNode16 = SAMPLE_TEXTURE2D(_PolyArtAlbedo, sampler_PolyArtAlbedo, input.uv);
                half4 tex2DNode13 = SAMPLE_TEXTURE2D(_Mask01, sampler_Mask01, input.uv);
                half4 tex2DNode41 = SAMPLE_TEXTURE2D(_Mask02, sampler_Mask02, input.uv);
                half4 emissionTex = SAMPLE_TEXTURE2D(_Emission, sampler_Emission, input.uv);
                
                // 颜色混合计算（保持原有逻辑）
                half4 temp_cast_0 = (tex2DNode13.r).xxxx;
                half4 temp_cast_1 = (tex2DNode13.g).xxxx;
                half4 temp_cast_2 = (tex2DNode13.b).xxxx;
                half4 temp_cast_3 = (tex2DNode41.r).xxxx;
                half4 temp_cast_4 = (tex2DNode41.g).xxxx;
                half4 temp_cast_5 = (tex2DNode41.b).xxxx;
                
                half4 blendOpDest22 = (
                    (min(temp_cast_0, _Color01) * _Color01Power) +
                    (min(temp_cast_1, _Color02) * _Color02Power) +
                    (min(temp_cast_2, _Color03) * _Color03Power) +
                    (min(temp_cast_3, _Color04) * _Color04Power) +
                    (min(temp_cast_4, _Color05) * _Color05Power) +
                    (min(temp_cast_5, _Color06) * _Color06Power)
                );
                
                half4 blendOpSrc22 = tex2DNode16;
                half4 blendedColor = saturate(blendOpSrc22 * blendOpDest22);
                
                half maskSum = tex2DNode13.r + tex2DNode13.g + tex2DNode13.b + 
                              tex2DNode41.r + tex2DNode41.g + tex2DNode41.b;
                
                half4 finalAlbedo = lerp(tex2DNode16, blendedColor, maskSum);
                
                // 自发光计算
                half4 blendOpSrc54 = emissionTex;
                half4 blendOpDest54 = _EmissionColor;
                half3 finalEmission = (saturate(blendOpSrc54 * blendOpDest54) * _EmissionPower).rgb;
                
                // URP光照计算
                InputData lightingInput = (InputData)0;
                lightingInput.positionWS = input.positionWS;
                lightingInput.normalWS = normalize(input.normalWS);
                lightingInput.viewDirectionWS = GetWorldSpaceNormalizeViewDir(input.positionWS);
                lightingInput.shadowCoord = TransformWorldToShadowCoord(input.positionWS);
                lightingInput.fogCoord = input.fogCoord;
                lightingInput.bakedGI = SAMPLE_GI(input.uv, half3(0,0,0), input.normalWS);
                
                SurfaceData surfaceData;
                surfaceData.albedo = finalAlbedo.rgb;
                surfaceData.alpha = finalAlbedo.a;
                surfaceData.emission = finalEmission;
                surfaceData.metallic = _Metallic;
                surfaceData.specular = half3(0.0h, 0.0h, 0.0h);
                surfaceData.smoothness = _Smoothness;
                surfaceData.normalTS = half3(0,0,1);
                surfaceData.occlusion = 1.0;
                surfaceData.clearCoatMask = 0.0h;
                surfaceData.clearCoatSmoothness = 0.0h;
                
                half4 color = UniversalFragmentPBR(lightingInput, surfaceData);
                color.rgb = MixFog(color.rgb, input.fogCoord);
                
                return color;
            }
            ENDHLSL
        }
        
        // 阴影投射Pass
        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}
            
            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull Back
            
            HLSLPROGRAM
            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment
            
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }
    }
    
    Fallback "Universal Render Pipeline/Lit"
}