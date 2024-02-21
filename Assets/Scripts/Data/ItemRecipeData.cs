using System;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New Item Recipe", menuName = "ScriptableObject/Recipe Data")]
public class ItemRecipeData : ScriptableObject
{
    // ID 또는 Data 중 하나는 삭제 예정
    [Tooltip("완성된 제작 아이템ID")]
    [SerializeField] private int itemID;
    [Tooltip("완성된 아이템 데이터")]
    [SerializeField] private ItemData itemData;
    [Tooltip("완성된 제작 아이템 개수")]
    [SerializeField] private int itemCount;
    [Tooltip("재료 아이템ID")] 
    [SerializeField] private List<int> craftItemID;
    [Tooltip("재료 아이템 데이터")]
    [SerializeField] private List<ItemData> craftItemData;
    [Tooltip("재료 아이템 개수")] 
    [SerializeField] private List<int> craftItemCount;

    public int ItemID { get => itemID; set => itemID = value; }
    public ItemData ItemData { get => itemData; set => itemData = value; }
    public int ItemCount { get => itemCount; set => itemCount = value; }
    public List<int> CraftItemID { get => craftItemID; set => craftItemID = value; }
    public List<ItemData> CraftItemData { get => craftItemData; set => craftItemData = value; }
    public List<int> CraftItemCount { get => craftItemCount; set => craftItemCount = value; }
}