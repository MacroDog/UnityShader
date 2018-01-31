// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/rim" {
        Properties {
            _MainTex ("Base (RGB)", 2D) = "white" {}
		_RimColor ("Rim Color (RGB)", Color) = (0.8,0.8,0.8,0.6)
		_RimPower ("Rim Power", Range(-2,50)) = 0.5

		_ShelterColor("Shelter Color",Color)=(0,0.6,1,1)
		_ShelterPower ("Shelter Power", Range(-2,50)) = 0.5
        }
        SubShader {

            Pass {
			 	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
				ZWrite Off
				Blend SrcAlpha One
                ZTest Greater
                Cull Back
				CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
     
      			sampler2D _MainTex;
                fixed4 _MainTex_ST;
				fixed4 _ShelterColor;
                fixed _ShelterPower;

                struct a2v
                {
                    fixed4 vertex : POSITION;
                    fixed3 normal : NORMAL;
                    fixed4 texcoord : TEXCOORD0;
     
                };
     
                struct v2f
                {
                    fixed4 pos : POSITION;
                    fixed4 rimColor : COLOR;
                };
     
                v2f vert (a2v v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos( v.vertex);

                	half rim = 1.0f - saturate( dot(normalize(ObjSpaceViewDir(v.vertex)), v.normal) );
					o.rimColor = (_ShelterColor.rgba * pow(rim, _ShelterPower));
                    return o;
                }
     
                fixed4 frag(v2f i) : COLOR
                {
                    fixed4 c=i.rimColor;
                    return c;
     
                }
     
                ENDCG
            }


             	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
      			ZTest LEqual
				ZWrite On
                Cull Back
                Lighting Off
              Pass {
                CGPROGRAM
//#pragma exclude_renderers d3d11 xbox360
                #pragma vertex vert
                #pragma fragment frag
     
                #include "UnityCG.cginc"
                sampler2D _MainTex;
                fixed4 _MainTex_ST;
                fixed _RimPower;
				fixed4 _RimColor;

                struct a2v
                {
                    fixed4 vertex : POSITION;
                    fixed3 normal : NORMAL;
                    fixed4 texcoord : TEXCOORD0;
     
                };
     
                struct v2f
                {
                    fixed4 pos : POSITION;
                    fixed2 uv :TEXCOORD0;
                    fixed3 rimColor : TEXCOORD1;
                };
     
                v2f vert (a2v v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos( v.vertex);
                    o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);  
                    	half rim = 1.0f - saturate( dot(normalize(ObjSpaceViewDir(v.vertex)), v.normal) );
			o.rimColor = (_RimColor.rgb * pow(rim, _RimPower));
                    return o;
                }
     
                fixed4 frag(v2f i) : COLOR
                {
                    fixed4 c = tex2D (_MainTex, i.uv);
                    c.rgb = c.rgb+i.rimColor;
                    return c;
     
                }
     
                ENDCG
            }


            FallBack "Diffuse"
}

//	FallBack "Mobile/VertexLit"
}
