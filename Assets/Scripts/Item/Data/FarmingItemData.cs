using UnityEngine;

[CreateAssetMenu(fileName = "New Farming Item", menuName = "ScriptableObject/Item Data/Farming Item")]
public class FarmingItemData : ItemData
{
    [SerializeField] private Define.FarmingType farmingType;
    
    public Define.FarmingType FarmingType => farmingType;
}