// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ForwardRendering" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Pass {
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _Glossiness;
			float _Metallic;
			struct a2v{
				float4 vertex: POSITION ;
				float4 normal: NORMAL;
				float4 texcoord : TEXCOORD0 ; 
			};
			struct v2f{
				float4 pos :SV_POSITION;
				float3 worldNormal:TEXCOORD1;
				float3 worldPos:TEXCOORD2;
				float2 uv : TEXCOORD0 ; 
			};
			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.vertex).xyz;
				return o;
			}
			float4 frag(v2f i):SV_Target{
				float3 worldNormal = normalize(i.worldNormal);
				//float3 worldLightDir = UnityWorldSpaceLightDir(i.worldPos) 
				float3 reflectDir  = normalize(_WorldSpaceLightPos0+(_WorldSpaceCameraPos-i.worldPos));
				float3 abedo = tex2D(_MainTex,i.uv).rgb*_Color.rgb;
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb*abedo;
				float3 diffuse = _LightColor0.rgb*abedo*max(0,dot(worldNormal,_WorldSpaceLightPos0));
				float3 sepecular  = _LightColor0.rgb * abedo*pow(max(0, dot(worldNormal,reflectDir)),_Glossiness);
				return float4 ((ambient+diffuse+sepecular),1.0f);
			}
			ENDCG
		}
		Pass {
			Tags{"LightMode"="ForwardAdd"}
			LOD 200
			Blend  One One 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdadd
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Glossiness;
			float4 _Color;
			float _Metallic;
			struct a2v
			{
				float4 vertex:POSITION ;
				float4 normal:NORMAL; 
				float4 texcoord:TEXCOORD0 ; 
			};
			struct v2f
			{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0 ;
				float3 worldNormal:TEXCOORD1  ;
				float3 worldPos:TEXCOORD2 ;  
			};
			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal).xyz;
				o.worldPos = mul(unity_WorldToObject,v.vertex).xyz;
				o.uv = v.texcoord.xy+_MainTex_ST.xy+_MainTex_ST.zw;
				return o;
			}
			float4 frag(v2f i):SV_Target{
				float3 worldNormal = normalize(i.worldNormal);
				#ifdef USING_DIRECTIONAL_LIGHT
					float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				#else 
					float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz-i.worldPos.xyz);
				#endif
				#ifdef USING_DIRECTIONAL_LIGHT
					float atten = 1;
				#else
					float3 lightCoord = mul(unity_WorldToLight,float4(i.worldPos,1)).xyz;
					float pos = dot(lightCoord,lightCoord);
					float atten = tex2D(_LightTexture0,float2(pos,pos)).UNITY_ATTEN_CHANNEL;
				#endif
				float3 reflectDir  = normalize(worldLightDir+(_WorldSpaceCameraPos-i.worldPos));
				float3 abedo = tex2D(_MainTex,i.uv).rgb*_Color.rgb;
				float3 diffuse = _LightColor0.rgb*abedo*max(0,dot(worldNormal,worldLightDir));
				float3 sepecular  = _LightColor0.rgb * abedo*pow(max(0, dot(worldNormal,reflectDir)),_Glossiness);
				return float4((abedo+diffuse+sepecular)*atten,1.0);
			}
			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
