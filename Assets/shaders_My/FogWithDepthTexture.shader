Shader "Custom/FogWithDepthTexture" {
	Properties {
		_MainTex("_MainTex",2D)="white"{}

	}
	SubShader {
		CGINCLUDE
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			sampler2D _CameraDepthTexture;
			float4x4 _FrusumCorrnesr;
			float4x4 _PreviousViewProjectionInverseMatrix;
			float4 _FogColor;
			float _FogDenisty;
			float _FogStart;
			float _FogEnd;
			float4x4 _FrusumCorrnesr;
			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv_depth : TEXCOORD1;
				float4 interpolatedRay : TEXCOORD2;
			};
			v2f vert(appdata_img v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.uv_depth = v.texcoord;
				int index = 0;
				if(v.texcoord.x < 0.5 && v.texcoord.y<0.5){
					index = 0;
				}else if(v.texcoord.x>0.5 && v.texcoord.y<0.5 ){
					index = 1;
				}else if(v.texcoord.x>0.5&&v.texcoord.y>0.5){
					index = 2;
				}else{
					index = 3;
				}
				#if UNITY_UV_STARTS_AT_TOP
					if(_MainTex_TexelSize.y<0){
						o.uv_depth = 1- o.uv_depth;
						index = 3 - index;
					}
				#endif
				o.interpolatedRay = _FrusumCorrnesr[index];
				return o;
			}
			float4 Frag(v2f i):SV_Target{
				float linearDepth =LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv_depth)) ;
				float3 worldPos =_WorldSpaceCameraPos + i.interpolatedRay.xyz*linearDepth;
				float fogDenisty = (_FogEnd-worldPos.y)/(_FogEnd-_FogStart);
				fogDenisty = saturate(fogDenisty*_FogDenisty);
				float4 finalColor = tex2D(_MainTex,i.uv);
				finalColor.rgb = lerp(finalColor.rgb,_FogColor.rgb,fogDenisty);
				return finalColor;
			}
		ENDCG
		Pass{
			ZTest Always ZWrite Off Cull Off
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment Frag
				#include "UnityCG.cginc"
			ENDCG
		}


	}
	FallBack Off
}
