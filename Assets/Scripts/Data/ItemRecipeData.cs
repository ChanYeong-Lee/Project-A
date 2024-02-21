using System;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New Item Recipe", menuName = "ScriptableObject/Recipe Data")]
public class ItemRecipeData : ScriptableObject
{
    // ID �Ǵ� Data �� �ϳ��� ���� ����
    [Tooltip("�ϼ��� ���� ������ID")]
    [SerializeField] private int itemID;
    [Tooltip("�ϼ��� ������ ������")]
    [SerializeField] private ItemData itemData;
    [Tooltip("�ϼ��� ���� ������ ����")]
    [SerializeField] private int itemCount;
    [Tooltip("��� ������ID")] 
    [SerializeField] private List<int> craftItemID;
    [Tooltip("��� ������ ������")]
    [SerializeField] private List<ItemData> craftItemData;
    [Tooltip("��� ������ ����")] 
    [SerializeField] private List<int> craftItemCount;

    public int ItemID { get => itemID; set => itemID = value; }
    public ItemData ItemData { get => itemData; set => itemData = value; }
    public int ItemCount { get => itemCount; set => itemCount = value; }
    public List<int> CraftItemID { get => craftItemID; set => craftItemID = value; }
    public List<ItemData> CraftItemData { get => craftItemData; set => craftItemData = value; }
    public List<int> CraftItemCount { get => craftItemCount; set => craftItemCount = value; }
}