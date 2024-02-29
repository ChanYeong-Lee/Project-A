using System;
using System.Collections.Generic;
using UnityEngine;

public class MonsterSpawner : MonoBehaviour
{
    [SerializeField] private List<GameObject> monsterPrefabs;
    [SerializeField] private List<int> spawnCount;
    [SerializeField] private List<Vector3> spawnPosition;

    private Dictionary<string, int> monsterDic = new Dictionary<string, int>();
    
    private void Start()
    {
        SpawnMonster();
    }

    private void SpawnMonster()
    {
        for (var i = 0; i < monsterPrefabs.Count; i++)
        {
            var prefab = monsterPrefabs[i];
            SpawnMonster(prefab, i);
        }
    }

    private void SpawnMonster(GameObject prefab, int prefabNum)
    {
        for (int i = 0; i < spawnCount[prefabNum]; i++)
        {
            GameObject monster = Managers.Pool.Pop(prefab);
            monster.transform.position = spawnPosition[prefabNum];
        }
        monsterDic.Add(prefab.name, spawnCount[prefabNum]);
    }

    private void Despawn(GameObject prefab)
    {
        
    }
}