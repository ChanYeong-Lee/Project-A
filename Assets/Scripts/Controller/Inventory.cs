using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    private Dictionary<ItemData, int> itemDataDic = new Dictionary<ItemData, int>();
    public Dictionary<ItemData, int> ItemDataDic { get => itemDataDic; set => itemDataDic = value; }

    // 아이템 사용
    public bool TryUseItem(ItemData itemData, int count = 1)
    {
        if (!itemDataDic.ContainsKey(itemData))
            return false;

        if (itemDataDic[itemData] == -1)
            return true;
        
        if (count > itemDataDic[itemData])
            return false;

        itemDataDic[itemData] -= count;
        
        return true;
    }
    
    // 아이템 획득 메소드
    public bool TryGainItem(ItemData itemData, int count = 1)
    {
        if (itemData == null)
            return false;
        
        if (!itemDataDic.TryAdd(itemData, count))
            itemDataDic[itemData] += count;

        return true;
    }

    // 아이템 제작 메소드
    public void CraftingItem(ItemRecipeData recipeData)
    {
        if (TryGainItem(recipeData.ItemData, recipeData.ItemCount))
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
    public int GetItemCount(ItemData itemData)
    {
        if (itemData == null || !itemDataDic.ContainsKey(itemData))
            return 0;

        if (itemDataDic[itemData] == -1)
            return 999;

        return itemDataDic[itemData];
    }
    
    public int GetItemCount(string id)
    {
        var item = itemDataDic.FirstOrDefault(itemData => itemData.Key.ItemID == id);

        return GetItemCount(item.Key);
    }
}