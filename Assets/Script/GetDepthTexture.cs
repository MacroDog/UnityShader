using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetDepthTexture : MonoBehaviour {
    public Camera cm;
	// Use this for initialization
	void Start () {
	    Camera.main.depthTextureMode |= DepthTextureMode.DepthNormals;
	    Camera.main.depthTextureMode |= DepthTextureMode.Depth;
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    void OnRenderImage(RenderTexture scourse ,RenderTexture destination) {
        cm.depthTextureMode
    }
}
