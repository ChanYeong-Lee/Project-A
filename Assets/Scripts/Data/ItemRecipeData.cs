using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New Item Recipe", menuName = "ScriptableObject/Recipe Data")]
public class ItemRecipeData : ScriptableObject
{
    // ID �Ǵ� Data �� �ϳ��� ���� ����
    [Tooltip("�ϼ��� ���� ������ID")]
    [SerializeField] private int itemID;
    [FormerlySerializedAs("itemData")]
    [Tooltip("�ϼ��� ������ ������")]
    [SerializeField] private Item item;
    [Tooltip("�ϼ��� ���� ������ ����")]
    [SerializeField] private int itemCount;
    [Tooltip("��� ������ID")] 
    [SerializeField] private List<int> craftItemID;
    [FormerlySerializedAs("craftItemData")]
    [Tooltip("��� ������ ������")]
    [SerializeField] private List<Item> craftItem;
    [Tooltip("��� ������ ����")] 
    [SerializeField] private List<int> craftItemCount;

    [Tooltip("���۵� ������")]
    [SerializeField] private ItemData itemData;
    [Tooltip("��� ������ ����Ʈ")]
    [SerializeField] private List<ItemData> craftItemData2;
    
    
    public int ItemID { get => itemID; set => itemID = value; }
    public Item Item { get => item; set => item = value; }
    public int ItemCount { get => itemCount; set => itemCount = value; }
    public List<int> CraftItemID { get => craftItemID; set => craftItemID = value; }
    public List<Item> CraftItemData { get => craftItem; set => craftItem = value; }
    public List<int> CraftItemCount { get => craftItemCount; set => craftItemCount = value; }
}