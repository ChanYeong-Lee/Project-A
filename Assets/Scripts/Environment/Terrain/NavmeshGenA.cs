/****

NOTE NOTE NOTE

1. Add this component to a terrain
2. Set your area ID's to be what you want the agent to think each surface in your terrain is (eg, Grass, Path), in the same order as the textures assigned in the terrain textures
3. Set "Defaultarea" to be whatever texture you expect to be the "most" common terrain texture. Generall this will be the first texture you assigned in step 1, eg "Grass"


IF THIS IS STILL TO SLOW:
- Adjust step to 2, 5, 10 or something higher

*/


using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using Unity.AI.Navigation;
using UnityEngine;
using UnityEngine.AI;

/** If this script seems to take forever, CHECK THE LAYERS YOUR NAV AGENT IS USING and filter out all the crap you don't need */
[RequireComponent(typeof(NavMeshSurface))]
public class NavMeshGenA : MonoBehaviour

{
    Terrain terrain;
    TerrainData terrainData;
    Vector3 terrainPos;

    /** This NEEDS to be a layer used by your Navigation agent */
    public String NavAgentLayer = "Default";
    public String defaultarea = "Walkable";
    /** Include trees collision in navigation mesh */
    public bool includeTrees;
    public float timeLimitInSecs = 20;
    /** How detailed will the edges of the terrain texture navmesh be? Smaller values mean larger generation times */
    public int step = 1;
    /** This should match the order of the terrain textures in use */
    public List<string> areaID;
    // Start is called before the first frame update
    void Start()
    {
    }

    [Button("Generate NavAreas")]
    void GenMeshes()
    {
        terrain = GetComponent<Terrain>();
        terrainData = terrain.terrainData;
        terrainPos = terrain.transform.position;

        Vector3 size = terrain.terrainData.size;
        Vector3 tpos = terrain.GetPosition();
        float minX = tpos.x;
        //tc.bounds.min.x;
        float maxX = minX + size.x;
        float minZ = tpos.z;
        float maxZ = minZ + size.z;

        GameObject attachParent;
        Transform childA = terrain.transform.Find("Delete me");

        if (childA != null)
        {
            attachParent = childA.gameObject;
        }
        else
        {
            attachParent = new GameObject();

            attachParent.name = "Delete me";
            attachParent.transform.SetParent(terrain.transform);
            attachParent.transform.localPosition = Vector3.zero;
        }

        int terrainLayer = LayerMask.NameToLayer(NavAgentLayer);
        int defaultWalkableArea = NavMesh.GetAreaFromName(defaultarea);
        //avMesh.GetAreaFromName("Walkable");
        Debug.Log("terrain pos:" + tpos);
        Debug.Log("terrain size:" + size);
        Debug.Log("minX:" + minX + ", maxX:" + maxX + ", minZ:" + minZ + ", maxZ:" + maxZ);

        // get the splat data for this cell as a 1x1xN 3d array (where N = number of textures)
        float[,,] splatmapData = terrainData.GetAlphamaps(0, 0, terrainData.alphamapWidth, terrainData.alphamapHeight);
        Debug.Log("alpha h width:" + terrainData.alphamapWidth + ", height:" + terrainData.alphamapHeight + ", resolution:" + terrainData.alphamapResolution);

        float alphaWidth = terrainData.alphamapWidth;
        float alphaHeight = terrainData.alphamapHeight;
        float tWidth = terrainData.size.x;
        float tHeight = terrainData.size.z;
        float startTime = Time.realtimeSinceStartup;
        float xStepsize = tWidth * ((float)1 / (float)alphaWidth);
        float zStepsize = tHeight * ((float)1 / (float)alphaHeight);

        Debug.Log("xStepSize:" + xStepsize);

        for (int dx = 0; dx <= alphaWidth; dx += step)
        {
            float xOff = tWidth * ((float)dx / (float)alphaWidth);
            for (int dz = 0; dz <= alphaHeight; dz += step)
            {
                float zOff = tHeight * ((float)dz / (float)alphaHeight);
                try
                {
                    int surface = GetMainTextureA(dz, dx, ref splatmapData);

                    int navArea = defaultWalkableArea;
                    if (areaID.Count > surface)
                        navArea = NavMesh.GetAreaFromName(areaID[surface]);

                    if (navArea == defaultWalkableArea)
                        continue;

                    if (Time.realtimeSinceStartup > startTime + timeLimitInSecs)
                    {
                        Debug.Log("Time limit exceeded");
                        goto escape;
                    }

                    //if (true)
                    //    continue;

                    Vector3 pos = new Vector3(minX + xOff, 0, minZ + zOff);
                    // Create a cube "step size" that is "slightly" above the height and mark it 
                    GameObject obj = new GameObject();
                    //GameObject.CreatePrimitive(PrimitiveType.Cube);
                    Transform objT = obj.transform;
                    objT.SetParent(attachParent.transform);
                    objT.localScale = Vector3.one;
                    objT.gameObject.layer = terrainLayer;
                    float height = terrain.SampleHeight(pos);
                    objT.position = new Vector3(pos.x, height, pos.z);
                    obj.isStatic = true;
                    NavMeshModifierVolume nmmv = obj.AddComponent<NavMeshModifierVolume>();
                    nmmv.size = new Vector3(xStepsize * step, 1, zStepsize * step);
                    nmmv.center = Vector3.zero;
                    nmmv.area = navArea;
                }
                catch (Exception e)
                {
                    // ignored
                }
            }
        }
        escape:
        //
        if (includeTrees)
        {
            Debug.Log("Now doing trees");
            TreeInstance[] instances = terrainData.treeInstances;
            TreePrototype[] prototypes = terrainData.treePrototypes;
            Vector3 tsize = terrainData.size;

            foreach (TreeInstance inst in instances)
            {
                TreePrototype prototype = prototypes[inst.prototypeIndex];

                Vector3 pos = (Vector3.Scale(inst.position, tsize));
                float rotY = inst.rotation;
                float hscale = inst.heightScale;
                float wscale = inst.widthScale;
                //Debug.Log("tree: " + (Vector3.Scale(pos, tsize)) + ", rot:" + rotY + ", hscale:" + hscale + ", wscale:" + wscale);

                GameObject tree = GameObject.Instantiate(prototype.prefab);
                Transform objT = tree.transform;
                objT.SetParent(attachParent.transform);
                objT.position = new Vector3(pos.x, pos.y, pos.z);
                objT.localRotation = Quaternion.Euler(0, Mathf.Deg2Rad * rotY, 0);
                objT.localScale = new Vector3(wscale, hscale, wscale);
                objT.gameObject.layer = terrainLayer;
                tree.isStatic = true;

            }

        }
        Debug.Log("Done prep, build nav mesh");
        foreach (NavMeshSurface nsurface in GetComponents<NavMeshSurface>())
        {
            //NavMeshSurface nsurface = GetComponent<NavMeshSurface>();
            nsurface.BuildNavMesh();
        }
        Debug.Log("Finished, destroy our temp objects");
        GameObject.DestroyImmediate(attachParent.gameObject);
    }

    void destroyChildren(Transform attachParent)
    {
        // Delete children from nav areas
        while (attachParent.childCount > 0)
            GameObject.DestroyImmediate(attachParent.GetChild(0).gameObject);

    }

    // Update is called once per frame
    void Update()
    {

    }

    /** https://answers.unity.com/questions/456973/getting-the-texture-of-a-certain-point-on-terrain.html */
    private float[] GetTextureMixA(int x, int z, ref float[,,] splatmapData)
    {
        // extract the 3D array data to a 1D array:
        float[] cellMix = new float[splatmapData.GetUpperBound(2) + 1];

        for (int n = 0; n < cellMix.Length; n++)
        {
            cellMix[n] = splatmapData[x, z, n];
        }
        return cellMix;
    }

    private int GetMainTextureA(int x, int z, ref float[,,] splatmapData)
    {
        // returns the zero-based index of the most dominant texture
        // on the main terrain at this world position.
        float[] mix = GetTextureMixA(x, z, ref splatmapData);

        float maxMix = 0;
        int maxIndex = 0;

        // loop through each mix value and find the maximum
        for (int n = 0; n < mix.Length; n++)
        {
            if (mix[n] > maxMix)
            {
                maxIndex = n;
                maxMix = mix[n];
            }
        }
        return maxIndex;
    }

}