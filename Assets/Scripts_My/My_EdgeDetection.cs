using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class My_EdgeDetection : My_PostEffectsBase {
    public Shader edgeDetectionShader;
    public Material edgeDetectionMaterial = null;
    public Material material {
        get {
            edgeDetectionMaterial = CheckShaderAndCreateMaterial(edgeDetectionShader, edgeDetectionMaterial);
            return edgeDetectionMaterial;
        }
    }

    [Range(0.0f, 1.0f)]
    public float edgeOnly = 0.0f;
    public Color edgeColor = Color.black;
    public Color backgoundColor = Color.white;
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
       
        if (material!=null)
        {
            material.SetFloat("_EdgeOnly", edgeOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BackgroundColor", backgoundColor);
            Graphics.Blit(source, destination, material);


        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

}
