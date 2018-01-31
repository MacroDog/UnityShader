// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MyGrabPass" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags{"Queue"="Transparent"}
     
        GrabPass
        {
            "_MyGrabTexture"
        }
       
        pass
        {
            Name "pass2"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"
            sampler2D _MyGrabTexture;
            float4 _MyGrabTexture_ST;

            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
                float4 scrPos :TEXCOORD1;
            } ;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.scrPos=ComputeScreenPos(o.pos);
                o.uv =  TRANSFORM_TEX(v.texcoord,_MyGrabTexture);
                return o;
            }
            float4 frag (v2f i) : COLOR
            {
                float4 texCol = tex2D(_MyGrabTexture,i.scrPos.xy/i.scrPos.w);
                if (texCol.w!=0)
                {
                    if (texCol.x != 1 && texCol.y!=1 && texCol.z!=1)
                    {
                        if (texCol.x != 0&&texCol.y!=0&&texCol.z!=0)
                        {
                            texCol = float4(1,1,1,texCol.w);
                        }
                      
                    }
                }
                return texCol;
            }
            ENDCG
        }
    }
}