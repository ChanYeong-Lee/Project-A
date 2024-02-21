using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class TestScript : MonoBehaviour
{
    public GameObject inven;
    
    public List<Item> itemList;
    
    private IEnumerator Start()
    {
        foreach (Item item in itemList)
        {
            inven.GetComponent<Inventory>().TryGainItem(item.Data, item.Count);
        }
        
        yield break;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("인벤 아이템 체크");
            foreach (KeyValuePair<ItemData, int> item in inven.GetComponent<Inventory>().ItemDataDic)
            {
                Debug.Log($"{item.Key.ItemName} : {item.Value}");
            }
        }
    }
}