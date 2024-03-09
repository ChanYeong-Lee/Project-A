using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using Random = UnityEngine.Random;

public class MonsterSpawner : MonoBehaviour
{
    [SerializeField] private List<GameObject> monsterPrefabs;
    [SerializeField] private List<int> spawnCount;
    [SerializeField] private List<Vector3> spawnPosition;

    private Dictionary<string, Vector3> monsterDic = new Dictionary<string, Vector3>();
    
    private List<GameObject> monsterList = new List<GameObject>();
    
    private void Start()
    {
        SpawnMonster();
        
        for (var i = 0; i < monsterPrefabs.Count; i++) 
            monsterDic.Add(monsterPrefabs[i].name, spawnPosition[i]);
    }

    // private void Update()
    // {
    //     // TODO : 몬스터 맵 밖으로 떨어지면 Despawn 시키기
    //     
    //     // Test Code
    //     {
    //         if (Input.GetKeyDown(KeyCode.Alpha1))
    //         {
    //             SpawnMonster();
    //         }
    //
    //         if (Input.GetKeyDown(KeyCode.Alpha2))
    //         {
    //             for (int i = 0; i < 5; i++)
    //             {
    //                 Despawn(monsterList[0].GetComponent<Monster>());
    //                 monsterList.RemoveAt(0);
    //             }
    //         }
    //
    //         if (Input.GetKeyDown(KeyCode.Alpha3))
    //         {
    //             foreach (GameObject monster in monsterList)
    //             {
    //                 monster.transform.rotation = quaternion.Euler(180, 0, 0);
    //             }
    //         }
    //     }
    // }

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
            
            monster.transform.position = transform.position + spawnPosition[prefabNum] + new Vector3(Random.value * 30,  0, Random.value * 30);

            if (Managers.Game.Player != null) 
                monster.GetComponent<Monster>().Target = Managers.Game.Player.transform;
            
            // Test Code
            monsterList.Add(monster);
        }
    }

    private IEnumerator CoRespawn(Monster monster)
    {
        // 몬스터 재생성 시간 추가해서 넣기
        yield return new WaitForSeconds(10);

        var go = Managers.Pool.Pop(monster.gameObject);
        
        if (monsterDic.TryGetValue(monster.name, out var pos))
        {
            go.transform.position = pos;
            go.transform.rotation = Quaternion.identity;
        }
    }
    
    public void Despawn(Monster monster)
    {
        monster.IsFarmable = false;
        
        Managers.Pool.Push(monster.gameObject);

        StartCoroutine(CoRespawn(monster));
    }
}