using UnityEngine;

public class Potion : Item
{
    [SerializeField] protected int healingPoint;
    
    public Potion(ItemData data, int count, int healingPoint) : base(data, count)
    {
        this.healingPoint = healingPoint;
    }
}