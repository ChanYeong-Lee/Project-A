using System;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using Random = UnityEngine.Random;

public class MonsterSpawner : MonoBehaviour
{
    [SerializeField] private List<GameObject> monsterPrefabs;
    [SerializeField] private List<int> spawnCount;
    [SerializeField] private List<Vector3> spawnPosition;
    
    private List<GameObject> monsterList = new List<GameObject>();
    
    private void Start()
    {
        SpawnMonster();
    }

    // Test Code
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            SpawnMonster();
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            for (int i = 0; i < 5; i++)
            {
                Despawn(monsterList[0]);
                monsterList.RemoveAt(0);
            }
        }

        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            foreach (GameObject monster in monsterList)
            {
                monster.transform.rotation = quaternion.Euler(180, 0, 0);
            }
        }
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
            GameObject monster = Managers.Resource.Instantiate(prefab, transform, true);
            
            monster.transform.position = transform.position + spawnPosition[prefabNum] + new Vector3(Random.value * 30,  5, Random.value * 30);

            if (Managers.Game.Player != null) 
                monster.GetComponent<Monster>().Target = Managers.Game.Player.transform;
            
            monsterList.Add(monster);
        }
    }
    
    private void Despawn(GameObject go)
    {
        Managers.Pool.Push(go);
    }
}