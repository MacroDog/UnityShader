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

    private RenderTexture accumulationTexture;

    void OnDisable() {
        DestroyImmediate(accumulationTexture);
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (material!=null) {
            if (accumulationTexture==null || accumulationTexture.width!=src.width||accumulationTexture.height!=src.height) {
               DestroyImmediate(accumulationTexture);
                accumulationTexture = new RenderTexture(src.width,src.height,0);
                accumulationTexture.hideFlags = HideFlags.HideAndDontSave;
                Graphics.Blit(src,accumulationTexture);
            }
            accumulationTexture.MarkRestoreExpected();
            material.SetFloat("_BlurAmount",blurAmount);
            Graphics.Blit(src,accumulationTexture,material);
            Graphics.Blit(accumulationTexture,dest);
        }
        else {
            Graphics.Blit(src,dest);
        }
    }

}
