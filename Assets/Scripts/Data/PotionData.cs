using UnityEngine;

[CreateAssetMenu(fileName = "New Potion", menuName = "ScriptableObject/Item Data/Potion")]
public class PotionData : ItemData
{
    [SerializeField] private int healingPoint;
    
    public int HealingPoint { get => healingPoint; }
}