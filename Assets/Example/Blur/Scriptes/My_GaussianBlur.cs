using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class My_GaussianBlur : My_PostEffectsBase {

    private Material gaussianBlurMaterial = null;
    public Shader gaussianBlurShader;
    public Material material {
        get {
            gaussianBlurMaterial = CheckShaderAndCreateMaterial(gaussianBlurShader,gaussianBlurMaterial);
            return gaussianBlurMaterial;
        }
    }
    [Range(0,4)]
    public int iterations = 3;
    [Range(0.2f, 3.0f)]
    public float blurSpread = 0.6f;
    [Range(1, 8)]
    public int downSample = 2;
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            int rtw = source.width;
            int rth = source.height;
            RenderTexture buffer = RenderTexture.GetTemporary(rtw, rth, 0);
            buffer.filterMode = FilterMode.Bilinear;
            Graphics.Blit(source, buffer, material, 0);
            Graphics.Blit(buffer, destination, material, 1);
            RenderTexture.ReleaseTemporary(buffer);
        }
        else
        {
            Graphics.Blit(source, destination);
            
        }
    }
    
}
