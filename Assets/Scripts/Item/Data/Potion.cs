using UnityEngine;

[CreateAssetMenu(fileName = "New Potion", menuName = "ScriptableObject/Item Data/Potion")]
public class Potion : Item
{
    [SerializeField] private int healingPoint;
    
    public int HealingPoint => healingPoint;
}