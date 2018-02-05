Shader "Custom/EdgeDetectNormalsAndDepth" {
	Properties {
		_MainTex("Base(RGB)",2D) = "white"{}
		_EdgeColor("Color",Color) = (1,1,1,1)
		_EdgeOnly("Edge Only", Float) = 1.0;
		_BackgroundColor("_BackgroundColor", Color) = (1,1,1,1)
		_SampleDistance("SampleDistance",Float) = 1.0
		_Sensitivity("Sensitivity",Vector) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGINCLUDE
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float4 _EdgeColor;
		float4 _EdgeOnly;
		float4 _BackgroundColor;
		float4 _SamplerDistance;
		float _Sensitivity;
		sampler2D _CameraNormalsAndDeth;
		struct v2f{
			float4 pos : SV_POSITION;
			float2 uv[5] : TEXCOORD0;
		};
		v2f vertex (appdata_img v){
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			float2 uv = v.TEXCOORD0;
			o.uv[0] = uv;
			#if UNITY_UV_STARTS_AT_TOP
			uv.y=1-uv.y;
			#endif
			o.uv[1] = uv + _MainTex_TexelSize*(1,1);
			o.uv[2] = uv + _MainTex_TexelSize*(-1,-1);
			o.uv[3] = uv + _MainTex_TexelSize*(-1,1);
			o.uv[4] = uv + _MainTex_TexelSize*(1,-1);
			return o;
		}

		float CheckSame(float4 center,float4 sampler){
			float2 centerNormal = center.xy;
			float centerDepth = DecodeFloatRG(center.zw);
			float2 samplerNormal = sampler.xy;
			float sampleDepth = DecodeFloatRG(sampler.zw);

		}

		float4 fragment(v2f i):SV_Target{

		}
		ENDCG

	}
	FallBack "Diffuse"
}
