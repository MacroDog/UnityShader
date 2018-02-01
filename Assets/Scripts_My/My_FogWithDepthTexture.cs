using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class My_FogWithDepthTexture : My_PostEffectsBase {

    public Shader FogWithDepthTextureShader;

    private Material FogMaterial = null;

    private Material material {
        get {
            FogMaterial = CheckShaderAndCreateMaterial(FogWithDepthTextureShader, FogMaterial);
            return FogMaterial;
        } 
    }

    public Transform transform;
    public Color FogColor;
    public float Denisty = 1.0f;
    public float Start;
    public float End;

    void OnRenderImage(RenderTexture sources, RenderTexture destination) {
        
    }
}
