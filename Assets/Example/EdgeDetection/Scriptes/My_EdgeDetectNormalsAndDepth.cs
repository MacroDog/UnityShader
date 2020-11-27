using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class My_EdgeDetectNormalsAndDepth : My_PostEffectsBase {
    public Shader EdgeDetectNormalsAndDepth;
    public Material material {
        get {
            EdgeDetect = CheckShaderAndCreateMaterial(EdgeDetectNormalsAndDepth, EdgeDetect);
            return EdgeDetect;
        }
    }

    private Material EdgeDetect = null;

    public Color _EdgeColor=Color.black;
    [Range(0, 1)]
    public float _EdgeOnly = 0.2f;
    public Color _BackgroundColor = Color.white;
    public float _SampleDistance;

    public float sensitivityNormals = 1;

    public float sensitivityDepth = 1;
	// Use this for initialization
	void Start () {
	    this.GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
	}
	
	// Update is called once per frame
    [ImageEffectOpaque]
    void OnRenderImage(RenderTexture source ,RenderTexture distance) {
        if (material) {
            material.SetColor("_EdgeColor", _EdgeColor);
            material.SetFloat("_EdgeOnly", _EdgeOnly);
            material.SetColor("_BackgroundColor", _BackgroundColor);
            material.SetFloat("_SampleDistance", _SampleDistance);
            material.SetVector("_Sensitivity",new Vector4(sensitivityNormals,sensitivityDepth,0,0));
            Graphics.Blit(source,distance,material);

        }
        else {
            Graphics.Blit(source, distance);
        }
       

    }
}
