using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class My_FogWithDepthTexture : My_PostEffectsBase {

    public Shader FogWithDepthTextureShader;

    private Material fogMaterial = null;

    public Material material {
        get {
            fogMaterial = CheckShaderAndCreateMaterial(FogWithDepthTextureShader, fogMaterial);
            return fogMaterial;
        }
    }

    private Transform transform;

    private Transform _Transform {
        get {
            if (!transform) {
                transform = GetComponent<Transform>();
            }
            return transform;
        }
    }

    private Camera camera = null;

    public Camera _Camera {
        get {
            if (!camera) {
                camera = GetComponent<Camera>();
            }
            return camera;
        }
    }

    void OnEnabel() {
        camera.depthTextureMode |= DepthTextureMode.Depth;
    }

    /// <summary>
    /// color of the fog
    /// </summary>
    public Color FogColor;
    /// <summary>
    /// concentration of fog
    /// </summary>
	[Range(0.0f, 3.0f)]
    public float FogDenisty = 1.0f;
    /// <summary>
    /// height of fog start
    /// </summary>
    public float FogStart = 0;
    /// <summary>
    /// height of fog end
    /// </summary>
    public float FogEnd = 2;


    void OnRenderImage(RenderTexture sources, RenderTexture destination) {
        if (material) {
            Matrix4x4 frusumCornesrs = Matrix4x4.identity;
            ;
            float near = _Camera.nearClipPlane;
            float faer = _Camera.farClipPlane;
            float fov = _Camera.fieldOfView;
            float aspect = _Camera.aspect;

            float halfheight = near * Mathf.Tan(fov * Mathf.Rad2Deg * 0.5f);
            Vector3 toTop = _Transform.up * halfheight;
            Vector3 toRight = _Transform.right * halfheight * aspect;
            Vector3 toNear = _Transform.forward * near;

            Vector3 toTL = toNear + toTop - toRight;
            float scale = toTL.magnitude / near;
            toTL.Normalize();
            toTL *= scale;
            Vector3 toTR = toNear + toTop + toRight;
            toTR.Normalize();
            toTR *= scale;
            Vector3 toBL = toNear - toTop - toRight;
            toBL.Normalize();
            toBL *= scale;
            Vector3 toBR = toNear - toTop + toRight;
            toBR.Normalize();
            toBR *= scale;

            // this order must be Fixed because this order will be used by shader
            frusumCornesrs.SetRow(0, toBL);
            frusumCornesrs.SetRow(1, toBR);
            frusumCornesrs.SetRow(2, toTR);
            frusumCornesrs.SetRow(3, toTL);
            Matrix4x4 _PreviousViewProjectionInverseMatrix = (camera.projectionMatrix * camera.cameraToWorldMatrix).inverse;
            material.SetMatrix("_FrusumCorrnesr", frusumCornesrs);
            material.SetMatrix("_PreviousViewProjectionInverseMatrix", _PreviousViewProjectionInverseMatrix);
            material.SetColor("_FogColor", FogColor);
            material.SetFloat("_FogDenisty", FogDenisty);
            material.SetFloat("_FogStart", FogStart);
            material.SetFloat("_FogEnd", FogEnd);
            Graphics.Blit(sources, destination, material);
        } else {
            Graphics.Blit(sources, destination);
        }
        // Graphics.Blit(sources, destination);
    }
}
