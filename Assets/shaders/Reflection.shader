// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Reflection" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_ReflectCubemap ("Albedo (RGB)", Cube) = "white" {}
		_ReflectionColor ("reflection Color",Color)=(1,1,1,1)
		_ReflectAmount ("Reflect Amount",Range(0,1))=0.8
		_RefractRatio("RefractRatio",Range(0.1,1))=0.5

	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment  frag
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			float4 _Color;
			samplerCUBE _ReflectCubemap;
			float4 _ReflectionColor;
			float _ReflectAmount;
			float _RefractRatio;
			struct a2v{
				float4 vertex : POSITION ;
				float4 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				float3 worldNormal : TEXCOORD1 ;
				float3 worldViewDir:TEXCOORD2;
				float3 worldRefrl: TEXCOORD3 ; 
				SHADOW_COORDS(4) 
			};
			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal).xyz;
				o.worldViewDir=  UnityWorldSpaceViewDir(o.worldPos).xyz;
				o.worldRefrl =refract(-normalize(o.worldViewDir),normalize(o.worldNormal) ,_RefractRatio).xyz;
				TRANSFER_SHADOW(o);
				return o;
			}
			float4 frag(v2f i):SV_Target{
				float3 worldNormal = normalize(i.worldNormal);
				float3 worldViewDir = normalize(i.worldViewDir);
				float3 worldLightDir = UnityWorldSpaceLightDir(i.worldPos);
				float3 ambient =UNITY_LIGHTMODEL_AMBIENT.xyz;
				float3 diffuse = _LightColor0.rgb*_Color.xyz*max(0,dot(i.worldNormal,worldLightDir));
				float3 reflection =texCUBE(_ReflectCubemap, i.worldRefrl).rgb * _ReflectionColor.rgb;
				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);
				float3 color = ambient +lerp(diffuse,reflection,_ReflectAmount) * atten;
				return float4(color,1.0);
			}
			ENDCG
		}
	}
	FallBack ""
}
