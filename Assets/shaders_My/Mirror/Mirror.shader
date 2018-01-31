// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Mirror" {
	Properties {
		_MainTex("MainTex",2D) = "white"{}
	}
	SubShader {
		Pass {
			Tags {"Queue" = "Geometry" "LightMode" = "ForwardBase"}
			LOD 200
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment  frag
			sampler2D _MainTex;
			float4 _MainTex_ST;
			struct a2v{
				fixed4 vertex : POSITION;
				fixed4 texcoord : TEXCOORD0; 
			};
			struct v2f{
				fixed4 pos : SV_POSITION;
				fixed2 uv : TEXCOORD0;  
			};
			v2f vert (a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord*_MainTex_ST.xy+_MainTex_ST.zw;
				return o;
			}
			fixed4 frag(v2f i) : COLOR{
				return tex2D(_MainTex,i.uv);
			}
			ENDCG 
		}
	}
	FallBack ""
}
