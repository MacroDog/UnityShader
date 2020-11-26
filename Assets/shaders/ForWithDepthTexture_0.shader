Shader "Custom/FogWithDepthTexture_0" {
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
			float4 _FogColor;
			float _FogDenisty;
			float _FogStart;
			float _FogEnd;
			struct v2f{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv_depth : TEXCOORD1;
			};
			v2f vert(appdata_img v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.uv_depth = v.texcoord;
				#if UNITY_UV_STARTS_AT_TOP
					if(_MainTex_TexelSize.y<0){
						o.uv_depth = 1- o.uv_depth;
					}
				#endif
				return o;
			}
			float4 GetWorldPosition(float2 uv,float linearDepth){
				//float4 _ProjectionParams;
				// x = 1 or -1 (-1 if projection is flipped)
				// y = near plane
				// z = far plane
				// w = 1/far plane
				float camPosZ = _ProjectionParams.y + (_ProjectionParams.z - _ProjectionParams.y) * linearDepth;
				// unity_CameraProjection._m11 = near / t，其中t是视锥体near平面的高度的一半。
				// 这里求的height和width是坐标点所在的视锥体截面（与摄像机方向垂直）的高和宽，并且
				// 假设相机投影区域的宽高比和屏幕一致。
				float height = 2 * camPosZ / unity_CameraProjection._m11;

				//float4 _ScreenParams;
				// x = width
				// y = height
				// z = 1 + 1.0/width
				// w = 1 + 1.0/height
				float width = _ScreenParams.x / _ScreenParams.y * height;

				float camPosX = width * uv.x - width / 2;
				float camPosY = height * uv.y - height / 2;
				float4 camPos = float4(camPosX, camPosY, camPosZ, 1.0);
				return mul(unity_CameraToWorld, camPos);

			}
			float4 Frag(v2f i):SV_Target{
				float linearDepth =LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv_depth)) ;
				//float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv_depth);
				float3 worldPos =GetWorldPosition(i.uv,linearDepth);
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
