using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New Item Recipe", menuName = "ScriptableObject/Recipe Data")]
public class ItemRecipeData : ScriptableObject
{
    // ID 또는 Data 중 하나는 삭제 예정
    [Tooltip("완성된 제작 아이템ID")]
    [SerializeField] private int itemID;
    [FormerlySerializedAs("itemData")]
    [Tooltip("완성된 아이템 데이터")]
    [SerializeField] private Item item;
    [Tooltip("완성된 제작 아이템 개수")]
    [SerializeField] private int itemCount;
    [Tooltip("재료 아이템ID")] 
    [SerializeField] private List<int> craftItemID;
    [FormerlySerializedAs("craftItemData")]
    [Tooltip("재료 아이템 데이터")]
    [SerializeField] private List<Item> craftItem;
    [Tooltip("재료 아이템 개수")] 
    [SerializeField] private List<int> craftItemCount;

    [Tooltip("제작된 아이템")]
    [SerializeField] private ItemData itemData;
    [Tooltip("재료 아이템 리스트")]
    [SerializeField] private List<ItemData> craftItemData2;
    
    
    public int ItemID { get => itemID; set => itemID = value; }
    public Item Item { get => item; set => item = value; }
    public int ItemCount { get => itemCount; set => itemCount = value; }
    public List<int> CraftItemID { get => craftItemID; set => craftItemID = value; }
    public List<Item> CraftItemData { get => craftItem; set => craftItem = value; }
    public List<int> CraftItemCount { get => craftItemCount; set => craftItemCount = value; }
}