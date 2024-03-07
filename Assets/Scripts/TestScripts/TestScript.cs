using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class TestScript : MonoBehaviour
{
    private Inventory inventory;
    
    public List<ItemData> itemList;

    private void Start()
    {
        inventory = Managers.Game.Inventory;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F2))
        {
            Debug.Log("인벤 아이템 체크");
            foreach (KeyValuePair<ItemData, int> item in inventory.ItemDataDic)
            {
                Debug.Log($"{item.Key.ItemName} : {item.Value}");
            }
        }

        if (Input.GetKeyDown(KeyCode.F1))
        {
            foreach (var item in itemList)
            {
                inventory.TryGainItem(item, 1);
            }
        }
    }
}