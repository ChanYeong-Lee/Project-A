using System;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    private Dictionary<ItemData, int> itemDataDic = new Dictionary<ItemData, int>();
    public Dictionary<ItemData, int> ItemDataDic { get => itemDataDic; set => itemDataDic = value; }

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
}