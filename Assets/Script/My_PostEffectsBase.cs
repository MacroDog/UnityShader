using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class My_PostEffectsBase : MonoBehaviour {

    protected void CheckResources()
    {
        bool isSupported = CheckSupport();
    }
	protected bool CheckSupport()
    {
        if (SystemInfo.supportsImageEffects==false)
        {
            Debug.LogWarning("This platform does not support image effect or render texture");
            return false;
        }
        return true;
    }
    protected void NotSupport()
    {
        enabled = false;
    }
    protected void Start()
    {
        CheckResources();
    }

    protected Material CheckShaderAndCreateMaterial(Shader shader,Material material)
    {
        if (shader == null)
        {
            return null;
        }
        if (shader.isSupported&&material!=null&&material.shader == shader)
        {
            return material;
        }
        if (!shader.isSupported)
        {
            return null;
        }
        else
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            if (material)
            {
                return material;
            }
            else
            {
                return null;
            }
        }
    }
}
