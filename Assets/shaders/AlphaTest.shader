// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/AlphaTest" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CutOff("CutOff",Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True"  "ReaderType"="TransparentCutout"}
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			float4 _Color;
			sampler2D _MainTex;
			float4 _MianTex_ST;
			float _CutOff;
			struct a2v{
				float4 vertex:POSITION ;
				float3 normal : NORMAL;
				float4  texcoord :TEXCOORD0 ; 
			};
			struct v2f{
				float4 pos :SV_POSITION;
				float3 worldPos:TEXCOORD0 ; 
				float2 uv :TEXCOORD1 ;
				float3 worldNormal:TEXCOORD2 ;
			};
			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.normal).xyz;
				o.uv = v.texcoord.xy*_MianTex_ST.xy+_MianTex_ST.zw;
				return o;
			}
			float4 frag(v2f i):SV_Target{
				float3 worldNormal = normalize(i.worldNormal);
				float3 worldLightDir =normalize(UnityWorldSpaceLightDir(i.worldPos)) ;
				float4 texColor  = tex2D(_MainTex,i.uv);
				clip(texColor.a-_CutOff);
				float3 albedo = texColor.rgb*_Color.rgb;
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb*albedo;
				float3 diffuse = _LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));
				return float4(ambient+diffuse,1.0f);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
