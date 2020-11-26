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
		_RefractionTex ("RefractionTex",Range(0,1)) = 1
	}
	SubShader
	{
		Tags {"Queue"="Transparent" "RenderType"="Opaque" }
		LOD 200
		GrabPass{"_RefractionTex"}
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
			sampler2D _RefractionTex;
			float4 _RefractionTex_TexselSize;
			struct a2v{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				float4 normal : NORMAL;
				float4 tangent : TANGENT;
			};
			struct v2f{
				float4 pos : SV_POSITION;
				float4 scrPos:TEXCOORD4 ; 
				float4 uv : TEXCOORD0 ;
				float4 TtoW0 : TEXCOORD1;
				float4 TtoW1 : TEXCOORD2;
				float4 TtoW2 : TEXCOORD3;
			};
			v2f vert(a2v v){
				v2f o ;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord*_MainTex_ST.xy+_MainTex_ST.zw;
				o.uv.zw = v.texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
				o.scrPos = ComputeScreenPos(o.pos);
				float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal).xyz;
				float3 worldTangent = mul(unity_ObjectToWorld,v.tangent).xyz;
				float3 worldBinormal = mul(worldNormal,worldTangent)*v.tangent.w;
				return o;
			}
			float4 frag(v2f i):SV_Target{
				float3 worldPos = float3(i.TtoW0.z,i.TtoW1.z,i.TtoW2.z);
				fixed3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
				fixed3 bump = UnpackNormal(tex2D(_BumpMap,i.uv.zw));
				float2 offset = bump.xy * _Distortion * _RefractionTex_TexselSize.xy;
				i.scrPos.xy = offset + i.scrPos.xy;  
				fixed3 refrCol = tex2D(_RefractionTex,i.scrPos.xy/i.scrPos.w).rgb;
				fixed3 finalColor = refrCol*(1-_RefractAmount) + refrCol * _RefractAmount;
				return fixed4(finalColor,1.0);
			}
			ENDCG
		}
	}
}
