using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New Item Recipe", menuName = "ScriptableObject/Recipe Data")]
public class ItemRecipeData : ScriptableObject
{
    [Tooltip("���۵� ������")]
    [SerializeField] private ItemData itemData;
    [Tooltip("��� ������ ����Ʈ")]
    [SerializeField] private List<ItemData> craftItemData;

    public ItemData ItemData => itemData;
    public IReadOnlyList<ItemData> CraftItemData => craftItemData;
}