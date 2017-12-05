// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/GlassReflection"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("Normal",2D  ) = "bump"{}
		_Cubemap ("CubeMap",Cube) = "SkyBox"{}
		_Distortion ("Distortion", Range(0,100)) = 10
		_RefractAmount ("RefractAmount",Range(0,10)) = 1.0 
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 200
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			sampler3D _Cubemap;
			float _Distortion;
			float _RefractAmount;
			struct a2v{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				float4 normal : NORMAL;
				float4 tangent : TANGENT;
			};
			struct v2f{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0 ;
				float4 TtoW0 : TEXCOORD1;
				float4 TtoW1 : TEXCOORD2;
				float4 TtoW2 : TEXCOORD3: 
			};
			v2f vert(a2v v){
				v2f o ;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord*_MainTex_ST.xy+_MainTex_ST.zw;
				o.uv.zw = v.texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
				float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal).xyz;
				float3 worldTangent = mul(unity_ObjectToWorld,v.tangent).xyz;
				float3 worldBinormal = mul(worldNormal,worldTangent)*v.tangent.w;
			}
			ENDCG
		}
	}
}
