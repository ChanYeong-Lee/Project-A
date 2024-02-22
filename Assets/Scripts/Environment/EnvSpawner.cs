using System;
using System.Collections.Generic;
using UnityEngine;

public class EnvSpawner : MonoBehaviour
{
    [SerializeField]
    private List<GameObject> treeList;
    
    private void Start()
    {
        foreach (var o in treeList)
        {
            var go = Managers.Pool.Pop(o, transform);
            go.transform.position = o.transform.position;
        }
    }
}