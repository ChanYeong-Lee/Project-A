using UnityEngine;

[CreateAssetMenu(fileName = "New Farming Item", menuName = "ScriptableObject/Item Data/Farming Item")]
public class FarmingItemData : ItemData
{
    [SerializeField] private Define.AttributeType attribute;

    
    public Define.AttributeType Attribute { get => attribute; set => attribute = value; }

}