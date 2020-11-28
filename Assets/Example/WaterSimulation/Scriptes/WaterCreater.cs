using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterCreater : MonoBehaviour
{
    public int WaveHight = 0;
    public int WaveWidth = 0;
    public int higthDivision = 0, widthDivision = 0;
    public Material material;
    private GameObject panel;
    // Start is called before the first frame update
    void Start()
    {
        if (WaveHight == 0 || WaveWidth == 0 || higthDivision == 0 || widthDivision == 0)
        {
            return;
        }
        panel = CreatMesh(WaveHight, WaveWidth, higthDivision, widthDivision);
        panel.name = "Water";
    }

    GameObject CreatMesh(int meshHight, int meshWidth, int higthDivision, int widthDivision)
    {
        GameObject gm = new GameObject();
        List<Vector3> points = new List<Vector3>();
        List<int> triangle = new List<int>();
        List<Vector2> uvs = new List<Vector2>();
        if (higthDivision == 0 || widthDivision == 0)
        {
            return null;
        }
        float higthStep = (float)meshHight / (float)higthDivision;
        float widthStep = (float)meshWidth / (float)widthDivision;
        float x = 0, y = 0;
        int indexX = 0, indexY = 0;
        for (indexY = 0; indexY < higthDivision; indexY++)
        {
            for (indexX = 0; indexX < widthDivision; indexX++)
            {
                x = indexX * widthStep;
                Vector3 temp = new Vector3(x, 0, y);
                points.Add(temp);
                uvs.Add(new Vector2((float)indexX / (float)widthDivision, (float)indexY / (float)higthDivision));
                if (indexY != 0 && indexX != 0)
                {
                    var temp1 = (indexX - 1) + (indexY) * widthDivision;
                    var temp2 = (indexX) + (indexY) * widthDivision;
                    var temp3 = (indexX - 1) + (indexY - 1) * widthDivision;
                    triangle.Add(temp1);
                    triangle.Add(temp2);
                    triangle.Add(temp3);
                    temp1 = (indexX) + (indexY) * widthDivision;
                    temp2 = indexX + (indexY - 1) * widthDivision;
                    triangle.Add(temp1);
                    triangle.Add(temp2);
                    triangle.Add(temp3);
                }
            }
            y = indexY * higthStep;
        }

        Mesh mesh = new Mesh()
        {
            vertices = points.ToArray(),
            uv = uvs.ToArray(),
            triangles = triangle.ToArray(),
        };
        mesh.RecalculateNormals();
        gm.AddComponent<MeshFilter>().mesh = mesh;
        gm.AddComponent<MeshRenderer>().material = material;
        return gm;
    }

    // GameObject CreatMesh()
    // {
    //     List<Vector3> points = new List<Vector3>(){
    //         new Vector3(0,0,0),
    //         new Vector3(2,0,0),
    //         new Vector3(2,0,2),
    //         new Vector3(0,0,2),

    //     };
    //     List<int> triangle = new List<int>(){
    //         2,1,0,
    //         3,2,0
    //     };
    //     List<Vector2> uvs = new List<Vector2>(){
    //         new Vector2(0,0),
    //         new Vector2(1,0),
    //         new Vector2(1,1),
    //         new Vector2(0,1),
    //     };
    //     GameObject gm = new GameObject();
    //     Mesh mesh = new Mesh()
    //     {
    //         vertices = points.ToArray(),
    //         uv = uvs.ToArray(),
    //         triangles = triangle.ToArray(),
    //     };
    //     mesh.RecalculateNormals();
    //     gm.AddComponent<MeshFilter>().mesh = mesh;
    //     gm.AddComponent<MeshRenderer>().material = material;
    //     return gm;
    // }

    // Update is called once per frame
    void Update()
    {

    }
}
