using System;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Collider[] detectedColliders;
    [SerializeField] private LayerMask gatheringLayerMask;
    [SerializeField] private Inventory inventory;

    private void Awake()
    {
        detectedColliders = new Collider[1];
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            Farming();
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

        Debug.Log($"{detectCount}");
        for (int i = 0; i < detectCount; i++)
        {
            var other = detectedColliders[i];

            Dictionary<FarmingItemData, int> dataDic = other.GetComponent<IFarmable>().Farming(out var farmingType);

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
            
            foreach (var data in dataDic)
            {
                inventory.TryGainItem(data.Key, data.Value);
                Debug.Log($"{data.Key} : {data.Value}");
            }
        }
    }
}
