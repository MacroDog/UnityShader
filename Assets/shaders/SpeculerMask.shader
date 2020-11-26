Shader "Custom/SpeculerMask" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor("specularColor",Color ) = (1,1,1,1)
		_SpecularMask("SpecularMask",2D ) = "white"{}
		_SpecularScale("SpecularScale",Float) = 1.0
		_BumpMap("Bump",2D) = "white"{}
		_BumpScale("BumpScale",Float) = 1.0
		_Gloss("Gloss",Float) = 1.0

	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _SpecularMask;
			float4 _SpecularColor;
			float _SpecularScale;
			sampler2D _BumpMap;
			float _BumpScale;
			float _Gloss;
			struct a2v
			{
				float4 vertex : POSITION ;
				float3 normal : NORMAL ;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;

			};
			struct v2f
			{
				float4 pos:SV_POSITION;
				float2 uv : TEXCOORD0 ;
				float3 tangentViewDir : TEXCOORD1;
				float3 tangentLightDir : TEXCOORD2;   
			};
			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
				float3 binormal = cross(v.normal,v.tangent.xyz)*v.tangent.w;				
				float3x3 rotation = float3x3( v.tangent.xyz, binormal, v.normal );
				o.tangentViewDir = mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;
				o.tangentLightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
				return o;
			}
			float4 frag(v2f i) :SV_Target{
				float3 tangentViewDir = normalize(i.tangentViewDir);
				float3 tangentLightDir = normalize(i.tangentLightDir);
				float3 tangentNormal = UnpackNormal(tex2D(_BumpMap,i.uv));
				tangentNormal.xy *=_BumpScale;
				tangentNormal.z = sqrt(1- saturate(dot(tangentNormal.xy,tangentNormal.xy)));
				float3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
				float3 diffuse = unity_LightColor0.rgb*albedo*max(0,dot(tangentNormal,tangentLightDir));
				float3 reflect = normalize(tangentViewDir+tangentLightDir);
				float3 speculaer = unity_LightColor0.rgb*albedo*tex2D(_SpecularMask,i.uv).rgb*pow(max(0,dot(tangentNormal,reflect)),_Gloss);
				return float4(ambient+diffuse+reflect+speculaer,1.0f);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
