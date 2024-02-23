using System;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private PlayerData playerData;
    [SerializeField] private LayerMask gatheringLayerMask;
    [SerializeField] private Inventory inventory;
    private Collider[] detectedColliders;
    
    private float time = 0;

    private void Awake()
    {
        detectedColliders = new Collider[1];
        playerData = Managers.Resource.Load<PlayerData>("ScriptableObject/Creature/Player Data");
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.F))
        {
            Farming();
        }

        if (Input.GetKeyUp(KeyCode.F))
        {
            time = 0;
        }

        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("인벤 아이템 체크");
            foreach (KeyValuePair<ItemData, int> item in inventory.GetComponent<Inventory>().ItemDataDic)
            {
                Debug.Log($"{item.Key.ItemName} : {item.Value}");
            }
        }
    }

    private void Farming()
    {
        Vector3 center = transform.TransformPoint(new Vector3(0, 1, 1));
        int detectCount = Physics.OverlapSphereNonAlloc(center, 1, detectedColliders, gatheringLayerMask);
        
        for (int i = 0; i < detectCount; i++)
        {
            var other = detectedColliders[i];
            
            Dictionary<FarmingItemData, int> dataDic = other.GetComponent<IFarmable>().Farming(out var farmingType);

            float farmingTime = playerData.FarmingTime;

            // 파밍 관련 애니메이션이나 기타 등등 스위치 문
            switch (farmingType)
            {
                case Define.FarmingType.None:
                    break;
                case Define.FarmingType.Gathering:
                    break;
                case Define.FarmingType.Felling:
                    break;
                case Define.FarmingType.Mining:
                    break;
                case Define.FarmingType.Dismantling:
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }

            Debug.Log($"{farmingType} : {other.name}");

            time += Time.deltaTime;
            if (farmingTime > time)
                return;
            
            foreach (var data in dataDic)
            {
                inventory.TryGainItem(data.Key, data.Value);
                Debug.Log($"{data.Key} : {data.Value}");
            }

            Managers.Pool.Push(other.gameObject);
        }
    }
}
