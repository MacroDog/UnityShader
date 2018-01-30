Shader "Custom/RenderDepth" {
    SubShader {
        Tags { "RenderType"="Opaque" }
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _CameraDepthTexture;
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = ComputeScreenPos(o.pos);
                return o;
            }

            half4 frag(v2f i) : SV_Target {
                float d = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture,i.uv));
                return (d,1,1,1);
            }
            ENDCG
        }
    }
    FallBack ""
}
