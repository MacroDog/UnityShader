// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MotionBlurWithDepthTexture" {
	Properties {
		_MainTex("Base(rgb)",2D)= "white"{}
		_BlurSize("BlurSize", Range(0.0, 1.0)) = (5.0)) 
	
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment Frag 
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float _BlurSize;
		sampler2D _CameraDepthTexture;
		float4x4 _PreviousViewProjectionMatrix;
		float4x4 _currentViewProjectInverseMatrix;
		struct v2f
		{
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0 ;
			float2 uv_depth:TEXCOORD1 ; 		
		};
		v2f vert( appdata_img v){
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord.xy;
			o.uv_depth = v.texcoord;
			#if UNITY_UV_STARTS_AT_TOP
				o.uv_depth.y=1-o.uv_depth.y;
			#endif
			return o;
		}
		float4 Frag(v2f i):SV_Target{
			
		}

		ENDCG
	}
	FallBack "Diffuse"
}
