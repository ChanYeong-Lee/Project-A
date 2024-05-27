using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    private Dictionary<Item, int> itemDataDic = new Dictionary<Item, int>();
    public Dictionary<Item, int> ItemDataDic { get => itemDataDic; set => itemDataDic = value; }

    // 아이템 사용
    public bool TryUseItem(Item item, int count = 1)
    {
        if (!itemDataDic.ContainsKey(item))
            return false;

        if (itemDataDic[item] == -1)
            return true;
        
        if (count > itemDataDic[item])
            return false;

        itemDataDic[item] -= count;
        
        return true;
    }
    
    // 아이템 획득 메소드
    public bool TryGainItem(Item item, int count = 1)
    {
        if (item == null)
            return false;
        
        if (!itemDataDic.TryAdd(item, count))
            itemDataDic[item] += count;

        return true;
    }

    // 아이템 제작 메소드
    public void CraftingItem(ItemRecipeData recipeData)
    {
        if (TryGainItem(recipeData.Item, recipeData.ItemCount))
        {
            for (int i = 0; i < recipeData.CraftItemData.Count; i++)
            {
                itemDataDic[recipeData.CraftItemData[i]] -= recipeData.CraftItemCount[i];
                if (itemDataDic[recipeData.CraftItemData[i]] <= 0)
                {
                    itemDataDic.Remove(recipeData.CraftItemData[i]);
                }
            }
        }
    }

    public void CraftingItem(ItemRecipeData recipeData, int count)
    {
        if (count < 1)
            return;
        
        for (int i = 1; i <= count; i++)
        {
            CraftingItem(recipeData);
        }
    }

    // 아이템 개수 가져오기
    public int GetItemCount(Item item)
    {
        if (item == null || !itemDataDic.ContainsKey(item))
            return 0;

        if (itemDataDic[item] == -1)
            return 999;

        return itemDataDic[item];
    }
    
    public int GetItemCount(string id)
    {
        var item = itemDataDic.FirstOrDefault(itemData => itemData.Key.ItemID == id);

        return GetItemCount(item.Key);
    }

    public Item FindItemData(string id)
    {
        var item = itemDataDic.FirstOrDefault(itemData => itemData.Key.ItemID == id);

        return itemDataDic.ContainsKey(item.Key) ? item.Key : null;
    }
}