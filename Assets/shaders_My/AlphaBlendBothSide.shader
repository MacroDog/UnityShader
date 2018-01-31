Shader "Custom/AlphaBlendBothSide" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_AlphaScale("alphaScale",Range(0,1))=1
	}
	SubShader {
		Tags { "RenderType"="Transparent" "IgnoreProjector"="True" "Queue"="Transparent" }
		LOD 200
		Pass {
				Tags { "LightMode"="ForwardBase" } 
				Blend SrcAlpha OneMinusSrcAlpha
				Cull Back
				ZWrite Off 
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "Lighting.cginc"
				#include "AutoLight.cginc"
				float4  _Color;
				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _AlphaScale;
				struct a2v{
					float4 vertex:POSITION ;
					float3 normal:NORMAL;
					float4 texcoord:TEXCOORD0 ; 
				};
				struct v2f{
					float4 pos:SV_POSITION;
					float2 uv : TEXCOORD0 ; 
					float3 worldNormal:TEXCOORD1;
					float3 worldPos: TEXCOORD2 ;
					SHADOW_COORDS(3)
				};
				v2f vert(a2v v){
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
					o.worldNormal = UnityObjectToWorldNormal(v.normal);
					o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
					TRANSFER_SHADOW(o);
					return o;
				}
				float4 frag(v2f i):SV_Target{
					float3 worldNormal = normalize(i.worldNormal);
					float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
					float4 texColor = tex2D(_MainTex,i.uv);
					float3 albedo = texColor.rgb*_Color.rgb;
					float3 ambient = albedo*UNITY_LIGHTMODEL_AMBIENT.rgb;
					float3 diffuse = _LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));
					UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);
					return float4(albedo+(ambient+diffuse)*atten,texColor.a*_AlphaScale);
				}
				ENDCG
			}
			Pass {
				Tags { "LightMode"="ForwardBase" } 
				Blend SrcAlpha OneMinusSrcAlpha
				Cull  Front
				ZWrite Off 
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "Lighting.cginc"
				#include "AutoLight.cginc"
				float4  _Color;
				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _AlphaScale;
				struct a2v{
					float4 vertex:POSITION ;
					float3 normal:NORMAL;
					float4 texcoord:TEXCOORD0 ; 
				};
				struct v2f{
					float4 pos:SV_POSITION;
					float2 uv : TEXCOORD0 ; 
					float3 worldNormal:TEXCOORD1;
					float3 worldPos: TEXCOORD2 ;
					SHADOW_COORDS(3)
				};
				v2f vert(a2v v){
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
					o.worldNormal = UnityObjectToWorldNormal(v.normal);
					o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
					TRANSFER_SHADOW(o);
					return o;
				}
				float4 frag(v2f i):SV_Target{
					float3 worldNormal = normalize(i.worldNormal);
					float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
					float4 texColor = tex2D(_MainTex,i.uv);
					float3 albedo = texColor.rgb*_Color.rgb;
					float3 ambient = albedo*UNITY_LIGHTMODEL_AMBIENT.rgb;
					float3 diffuse = _LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));
					UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);
					return float4(albedo+(ambient+diffuse)*atten,texColor.a*_AlphaScale);
				}
				ENDCG
			}
			

	}
	FallBack "Diffuse"
}
