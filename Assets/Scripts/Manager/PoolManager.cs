using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Pool;

public class PoolManager
{
    private Dictionary<string, Pool> pools = new Dictionary<string, Pool>();

    private void CreatePool(GameObject original)
    {
        Pool pool = new Pool(original);
        pools.Add(original.name, pool);
    }

    public GameObject Pop(GameObject prefab, Transform parent = null)
    {
        if (!pools.ContainsKey(prefab.name)) 
            CreatePool(prefab);

        Pool pool = pools[prefab.name];
        pool.Parent = parent;
        
        return pool.Pop();
    }

    public bool Push(GameObject go)
    {
        if (!pools.ContainsKey(go.name))
            return false;

        pools[go.name].Push(go);

        return true;
    }

    public void Clear()
    {
        pools.Clear();
    }
}

internal class Pool
{
    private GameObject prefab;
    private IObjectPool<GameObject> pool;
    private Transform parent;

    public Transform Parent
    {
        get
        {
            if (parent == null)
            {
                GameObject go = new GameObject($"{prefab.name} Pool");
                parent = go.transform;
            }

            return parent;
        }
        set => parent = value;
    }

    public Pool(GameObject prefab)
    {
        this.prefab = prefab;
        pool = new ObjectPool<GameObject>(OnCreate, OnGet, OnRelease, OnDestroy);
    }

    public void Push(GameObject go)
    {
        if (go.activeSelf)
            pool.Release(go);
    }

    public GameObject Pop()
    {
        return pool.Get();
    }

    private GameObject OnCreate()
    {
        GameObject go = GameObject.Instantiate(prefab);
        go.transform.SetParent(parent);
        go.name = prefab.name;

        return go;
    }

    private void OnGet(GameObject go)
    {
        go.SetActive(true);
    }

    private void OnRelease(GameObject go)
    {
        go.SetActive(false);
    }

    private void OnDestroy(GameObject go)
    {
        GameObject.Destroy(go);
    }
}