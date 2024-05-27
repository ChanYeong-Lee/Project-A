using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New Item Recipe", menuName = "ScriptableObject/Recipe Data")]
public class ItemRecipeData : ScriptableObject
{
    [Tooltip("제작된 아이템")]
    [SerializeField] private ItemData itemData;
    [Tooltip("재료 아이템 리스트")]
    [SerializeField] private List<ItemData> craftItemData;

    public ItemData ItemData => itemData;
    public IReadOnlyList<ItemData> CraftItemData => craftItemData;
}