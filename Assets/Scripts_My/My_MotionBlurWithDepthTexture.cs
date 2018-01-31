using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class My_MotionBlurWithDepthTexture : My_PostEffectsBase {

    public Shader MotionBlur;
    public Material MotionBlurMaterial;
    public Material material {
        get {
            Material temp = CheckShaderAndCreateMaterial(MotionBlur,MotionBlurMaterial);
            return material;
        }
    }

    [Range(0.0f,1.0f)]
    public float blurSize = 0.5f;

    private Matrix4x4 previousMatrix;
    public Camera Camera {
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
        camera.depthTextureMode |= DepthTextureMode.DepthNormals;
        camera.depthTextureMode |= DepthTextureMode.Depth;
    }
    void OnRenderImage(RenderTexture sources, RenderTexture destination) {
        if (!material) {
            material.SetFloat("_BlurSize",blurSize);
            material.SetMatrix("_PreviousViewProjectionMatrix", previousMatrix);
            Matrix4x4 currentViewProjectMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
            Matrix4x4 currentViewProjectInverseMatrix = currentViewProjectMatrix.inverse;
            material.SetMatrix("_currentViewProjectInverseMatrix",currentViewProjectInverseMatrix);
            Graphics.Blit(sources,destination,material);
            previousMatrix = currentViewProjectMatrix;
        }
        else {
            Graphics.Blit(sources,destination,material);
        }
    }

}
