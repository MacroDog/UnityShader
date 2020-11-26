// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/CartoonShading" {
	Properties {
		_MainTex("Base(RGB)",2D)  = "white"{}
		_Color("Color Tint",Color) = (1,1,1,1)
		_Ramp("RampTexture",2D)= "white"{}
		_Outline("Outline",Range(0,1)) = 0.1
		_OutlineColor("OutlineColor",Color) = (1,1,1,1)
		_Specular("Specular",Color) = (1,1,1,1)
		_SpecularScale("SpecularColor",Range(0,0.1)) =0.01
	}
	SubShader {
		Pass{
			NAME "OUTLINE"
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float _Outline;
			float4 _OutlineColor;
			struct a2v{
				float4 vertex : POSITION;
				float3 normal :NORMAL;
			};

			struct v2f{
				float4 pos : SV_POSITION;
			};

			v2f vert(a2v v){
				v2f o;
				float4 pos = mul(UNITY_MATRIX_MV, v.vertex);
				float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV,v.normal);
				normal.z = -0.5;
				pos = pos + float4(normalize(normal),0) * _Outline;
				o.pos = mul(UNITY_MATRIX_P,pos);
				return o;
			}
			float4 frag(v2f i):SV_Target{
				return float4(_OutlineColor.rgb,1);
			}
			ENDCG
		}
		Pass{
			Tags{"LightMode"="ForwardBase"}
			Cull Back
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			sampler2D _Ramp;
			float4 _Specular;
			float _SpecularScale;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				SHADOW_COORDS(3)
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
				o.worldNormal = mul(v.normal,unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				TRANSFER_SHADOW(o);
				return o;
			}
			float4 frag(v2f i):SV_Target{
				float3 worldNormalDir = normalize(i.worldNormal);
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 worldHalfDir = normalize(worldLightDir+worldViewDir);
				float4 c = tex2D(_MainTex,i.uv);
				float3 albedo = c.rgb + _Color.rgb;
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz *albedo;
				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);
				fixed diff = dot(worldNormalDir,worldLightDir);
				diff = ( diff * 0.5 + 0.5 ) * atten;
				fixed3 diffuse = _LightColor0*ambient*albedo*tex2D(_Ramp,float2(diff,diff)).rgb;
				fixed spec = dot(worldNormalDir,worldHalfDir);
				fixed w = fwidth(spec)*2;
				fixed3 specular = _Specular.rgb *lerp(0,1,smoothstep(-w,w,spec+_SpecularScale-1)) * step(0.0001,_SpecularScale);
				return float4(ambient + diffuse +specular,1);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
