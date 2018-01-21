using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class My_MotionBlur : PostEffectsBase {

    public Shader MotionShader;
    private Material motionMaterial = null;
    public Material material {
        get {
            motionMaterial = CheckShaderAndCreateMaterial(MotionShader,motionMaterial);
            return motionMaterial;
        }
    }
    [Range(0f,0.9f)]
    public float blurAmount = 0.5f;

    private RenderTexture rendertexture;

}
