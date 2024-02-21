using System.Collections.Generic;
using UnityEngine;

public class ResourceManager
{
    // key : prefab path
    private Dictionary<string, Object> resources = new Dictionary<string, Object>();

    public T Load<T>(string key) where T : Object
    {
        if (resources.TryGetValue(key, out Object resource))
            return resource as T;

        T t = Resources.Load<T>(key);
        resources.Add(key, t);
        
        return t;
    }

    public T[] LoadAll<T>(string key) where T : Object
    {
        T[] objects = Resources.LoadAll<T>(key);

        foreach (var obj in objects)
        {
            if (!resources.TryGetValue($"{key}/{obj.name}", out _))
            {
                resources.Add($"{key}/{obj.name}", obj);
            }
        }

        return objects;
    }

    // 주소값으로 생성
    public GameObject Instantiate(string key, Transform parent = null, bool pooling = false)
    {
        GameObject prefab = Load<GameObject>($"{key}");

        if (prefab == null)
            return null;

        if (pooling)
            return Managers.Pool.Pop(prefab);

        GameObject go = Object.Instantiate(prefab, parent);

        go.name = prefab.name;

        return go;
    }

    // 프리팹으로 생성
    public GameObject Instantiate(GameObject prefab, Transform parent = null, bool pooling = false)
    {
        if (prefab == null)
            return null;
        
        if (pooling)
            return Managers.Pool.Pop(prefab);

        GameObject go = Object.Instantiate(prefab, parent);

        go.name = prefab.name;

        return go;
    }

    public void Destroy(GameObject go)
    {
        if (go == null)
            return;

        if (Managers.Pool.Push(go))
            return;

        Object.Destroy(go);
    }

    public void Clear()
    {
        resources.Clear();
    }
}