// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/NormalWorldSpace" {
Properties{
	_Color("Color Tint",Color) = (1,1,1,1)
	_MainTex("Main Tex",2D) = "white"{}
	_BumpScale("Bump Scale",Float) = 1.0
	_Specular("Specular",Color) = (1,1,1,1)
	_Gloss("Gloss",Range(80,256)) = 20	
	}
	SubShader{
		Pass{
			CGPROGRAM
			#pragme vertex vert
			#pragme fragment frag
			# include "Lighting.cginc"
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;
			struct a2v{
				float4 vertex:POSITION;
				float3 texcoord: TEXCOORD0;
				float normal:NORMAL;
				float tangent:TANGENT;
			};
			struct v2f{
				float4 pos : SV_POSITION;
				float3 uv:TEXCOORD0;
				float4 TtoW0 : TEXCOORD1;
				float4 TtoW1 : TEXCOORD2;
				float4 TtoW2 : TEXCOORD3;
			};
			v2f vert(a2f v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord.xy*_MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.xy = v.texcoord.xy*_MainTex_ST.xy + _MainTex_ST.zw;
				float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldTengent = UnityObjectToWorldNormal(v.tangent);
				float3 worldbinomal = cross(worldNormal.xyz,worldTengent.xyz)*v.tengent.w;
				o.TtoW0 = (worldPos.x , worldbinomal.x,worldNormal.x ,worldTengent.x);
				o.TtoW1 = (worldPos.y,worldbinomal.y,worldNormal.y,worldTengent.y);
				o.TtoW2 = (worldPos.z ,worldbinomal.z, worldNormal.z, worldTengent.z);
				return o;
			}
			float4 freg(v2f i):SV_Traget{
				float3 worldPos = (i.TtoW0.x,i.TtoW1.x ,i.TtoW2.x);
				float3 worldbinomal = (i.TtoW0.y,i.TtoW1.y,i.TtoW2.y);
				float3 worldNormal = (i.TtoW0.z ,i.TtoW1.z,i.TtoW2.z);
				float3 worldTengent = (i.TtoW0.w,i.TtoW1.w,i.TtoW2.w);
				float3 LightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				float3 viewDir =  normalize(UnityWorldSpaceViewDir(worldPos));
				float3 bump = UnpackNormal(tex2D(_BumpMap,i.uv.zw));
				bump.xy *= _BumpScale;
				bump.z = sqrt(1.0 - saturate(dot(bump.xy,bump.xy)));
				bump = 
				}
			ENDCG
		}
	}
	
	FallBack "Diffuse"
}
