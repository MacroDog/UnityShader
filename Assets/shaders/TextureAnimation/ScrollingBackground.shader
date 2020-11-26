// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ScrollingBackground" {
	Properties {
		_MainTex("MainTex",2D ) = "white"{}
		_DetailTex("DetailTex",2D ) = "white"{}
		_ScrollX("Base layer Scroll Speed",Float) = 1.0
		_Scroll2X("2nd layer Scroll Speed",Float) = 1.0
		_Multiplier("Layer Mutilplier",Float) = 1
	}
	SubShader {		
		LOD 200
		Pass {
			Tags{"RenderType"="Transparent" "Quaua" = "Transparent""IgnoreProjector"="True"}
			LOD 200
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment  frag
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DetailTex;
			float4 _DetailTex_ST;
			float _ScrollX;
			float _Scroll2X;
			float _Multiplier;
			struct a2v
			{
				float4 vertex:POSITION;
				float4 texcoord:TEXCOORD0; 
			};
			struct v2f
			{
				float4 pos :SV_POSITION;
				float4 uv :TEXCOORD0 ; 
			};
			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord,_MainTex) + frac(float2(_ScrollX,0.0)*_Time.y);
				o.uv.zw = TRANSFORM_TEX(v.texcoord,_DetailTex) + frac(float2(_Scroll2X,0.0)*_Time.y);
				return o;
			}
			fixed4 frag(v2f i):SV_Target {
				float4 colorx = tex2D(_MainTex,i.uv.xy);
				float4 color2X = tex2D(_DetailTex,i.uv.zw);
				fixed3 color = lerp(colorx,color2X,color2X.a);
				color.rgb*=_Multiplier;
				return fixed4(color,1);
			} 
			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
