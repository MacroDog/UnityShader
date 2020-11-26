Shader "Custom/Dissolve_TextureCoords"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Notice ("Notice",2D) = "white"{}
		_Color("Color",Color) = (1,1,1,1)
		_DissolveThreshold("DissolveThreshold",Range(0,1)) = 0.1  //溶解度
		_DissolveColor("DissolveColor",Color) = (1,1,1,1)
		_ColorFactor("ColorFactor", Range(0,1)) = 0.7
		_DissEdgeColor("DissEdgeColor",Color) = (1,1,1,1)
		_DissolveEdge("DissolveEdge", Range(0,1)) = 0.8
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Notice;
			float _DissolveThreshold;
			float4 _DissolveColor;
			float4 _DissEdgeColor;
			float4 _Color;
			float _ColorFactor;
			float _DissolveEdge;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 dissolveValue = tex2D(_Notice,i.uv);
				if(dissolveValue.r < _DissolveThreshold)
				{
					discard;
				}
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb*=_Color.rgb;
				fixed4 ClipTex = tex2D(_Notice,i.uv);
				float percentage = _DissolveThreshold/dissolveValue.r;
				float lerpEdge = sign(percentage - _ColorFactor - _DissolveEdge);
				 fixed3 edgeColor = lerp(_DissEdgeColor.rgb, _DissolveColor.rgb, saturate(lerpEdge));
				 float lerpOut = sign(percentage - _ColorFactor);
         //最终颜色在原颜色和上一步计算的颜色之间差值（其实经过saturate（sign（..））的lerpOut应该只能是0或1）
         fixed3 colorOut = lerp(col, edgeColor, saturate(lerpOut));
				return fixed4(colorOut,1);
			}
			ENDCG
		}
	}
}
