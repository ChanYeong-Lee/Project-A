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
            Debug.Log("입력");
            Vector3 center = transform.TransformPoint(new Vector3(0, 1, 1));
            int detectCount = Physics.OverlapSphereNonAlloc(center, 1, detectedColliders, gatheringLayerMask);

            Debug.Log($"{detectCount}");
            for (int i = 0; i < detectCount; i++)
            {
                var other = detectedColliders[i];
                Debug.Log($"{other.gameObject.layer}, {other.gameObject.name}");
                (ItemData, int) itemData = other.GetComponent<IFarmable>().Farming();

                inventory.TryGainItem(itemData.Item1, itemData.Item2);
            }
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
    
    
        
}
