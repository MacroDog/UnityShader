Shader "Custom/sketch" {
	Properties {
		_MainTex("Base(RGB)",2D ) = "white"{}
		_Color("Color",COLOR) = (1,1,1,1)
		_PencilTex0("Pencil Texture0",2D ) = "white"{}
		_PencilTex1("Pencil Texture1",2D ) = "white"{}
		_PencilTex2("Pencil Texture2",2D ) = "white"{}
		_PencilTex3("Pencil Texture3",2D ) = "white"{}
		_PencilTex4("Pencil Texture4",2D ) = "white"{}
		_PencilTex5("Pencil Texture5",2D ) = "white"{}
		_PeperTex("Paper Texture",2D ) = "white"{}
		_TileFactor("Tile Factor",Float) = 1
		_TileFactor2("Tile Factor",Float) = 1
	}
	SubShader {
		Tags{"RenderType"="Opaque"}
		LOD 200
		Pass {
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#pragma glsl
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"
			#define DegreeToRadian 0.0174533
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _PencilTex0;
			sampler2D _PencilTex1;
			sampler2D _PencilTex2;
			sampler2D _PencilTex3;
			sampler2D _PencilTex4;
			sampler2D _PencilTex5;
			sampler2D _PeperTex;
			float4 _Color;
			float _TileFactor;
			float _TileFactor2;
			struct a2v
			{
				float4 vertex : POSITION ;
				float3 normal:NORMAL;
				float4 tangent :TANGENT;
				float4 texcoord :TEXCOORD0 ; 
			};
			struct v2f
			{
				float4 pos:POSITION;
				float4 scrPos:TEXCOORD0 ;
				float3 worldNormal:TEXCOORD1 ;
				float3 worldLightDir:TEXCOORD2; 
				float3 worldPos:TEXCOORD3;				
			};
			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldLightDir = UnityWorldSpaceLightDir(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				o.scrPos = ComputeScreenPos(o.pos);
				TRANSFER_SHADOW(o);
				return o; 
			}
			float4 frag(v2f i):COLOR{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(i.worldLightDir);
				fixed3 scrPos = i.scrPos.xyz/i.scrPos.w*_TileFactor;
				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);
				fixed diff = (dot(worldNormal,worldLightDir)*0.5+0.5)*atten*6;
				fixed3 fragColor;
				if (diff<1.0)
				{
					fragColor = tex2D(_PencilTex0,scrPos).rgb;
				}else if (diff<2.0)
				{
					fragColor = tex2D(_PencilTex1,scrPos).rgb;
				}else if (diff<3.0)
				{
					fragColor = tex2D(_PencilTex2,scrPos).rgb;
				}else if (diff < 4.0)
				{
					fragColor = tex2D(_PencilTex3,scrPos).rgb;
				}
				else if (diff< 5.0)
				{
					fragColor = tex2D(_PencilTex4,scrPos).rgb;
				}
				else 
				{
					fragColor = tex2D(_PencilTex5,scrPos).rgb;
				}
				fragColor *=_Color.rgb*_LightColor0.rgb;
				return fixed4(fragColor,1.0);
			}
			ENDCG
		}
	}
	FallBack ""

}
