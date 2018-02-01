using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class My_MotionBlurWithDepthTexture : My_PostEffectsBase {

    public Shader MotionBlur;
    private Material MotionBlurMaterial = null;
    public Material material {
        get {
            MotionBlurMaterial = CheckShaderAndCreateMaterial(MotionBlur,MotionBlurMaterial);
            return MotionBlurMaterial;
        }
    }

    [Range(0.0f,1.0f)]
    public float blurSize = 0.5f;

    private Matrix4x4 previousMatrix;
    public Camera _Camera {
        get {
            if (!camera) {
                camera = GetComponent<Camera>();
                if (!camera) {
                    Debug.LogError("_need camera");
                }
            }
            return camera;
        }
    }

    private Camera camera = null;

    void OnEnable() {
        _Camera.depthTextureMode |= DepthTextureMode.Depth;

        previousMatrix = _Camera.projectionMatrix * _Camera.worldToCameraMatrix;
    }
    void OnRenderImage(RenderTexture sources, RenderTexture destination) {
        if (material) {
            material.SetFloat("_BlurSize",blurSize);
            material.SetMatrix("_PreviousViewProjectionMatrix", previousMatrix);
            Matrix4x4 currentViewProjectMatrix = _Camera.projectionMatrix * _Camera.worldToCameraMatrix;
            Matrix4x4 currentViewProjectInverseMatrix = currentViewProjectMatrix.inverse;
            material.SetMatrix("_CurrentViewProjectionInverseMatrix", currentViewProjectInverseMatrix);
            previousMatrix = currentViewProjectMatrix;
            Graphics.Blit(sources,destination,material);
            
        }
        else {
            Graphics.Blit(sources,destination,material);
        }
    }

}
