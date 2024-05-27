using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;

public class EnvSpawner : MonoBehaviour
{
    [SerializeField] private List<GameObject> envPrefabs;
    private List<Environment> envList;
    
    private void Start()
    {
        envList = new List<Environment>(GetComponentsInChildren<Environment>());

        foreach (var go in GetComponentsInChildren<Transform>())
        {
            if (go.GetComponent<EnvSpawner>())
                continue;
            
            // go.gameObject.SetActive(false);
            Destroy(go.gameObject);
        }
        
        foreach (var env in envList)
        {
            Spawn(env);
        }
    }

    private GameObject Spawn(Environment env)
    {
        var go = Managers.Pool.Pop(envPrefabs[Random.Range(0, envPrefabs.Count)], transform);
        
        go.transform.position = env.transform.position;
        go.transform.rotation = env.transform.rotation;
        go.transform.localScale = env.transform.lossyScale;

        return go;
    }

    private IEnumerator CoRespawn(Environment env)
    {
        var scale = env.transform.lossyScale;
        yield return new WaitForSeconds(env.EnvData.RespawnTime);
        
        var go = Spawn(env);
        
        for (int i = 1; i <= Define.GrowthTime; i++)
        {
            go.transform.localScale = Vector3.Lerp(scale * 0, scale, (float)i / Define.GrowthTime);
            
            yield return null;
        }

        env.IsFarmable = true;
    }

    public void Despawn(Environment env)
    {
        env.IsFarmable = false;
        Managers.Pool.Push(env.gameObject);
        StartCoroutine(CoRespawn(env));
    }
}