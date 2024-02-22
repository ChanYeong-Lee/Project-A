using System.Collections.Generic;
using UnityEngine;

public abstract class Monster : Creature, IFarmable
{
    [SerializeField] protected List<ItemData> dropItem;
    
    public List<ItemData> DropItemList => dropItem;


    public override void Init()
    {
        base.Init();
    }


    public (ItemData, int) Farming()
    {
        return (dropItem[0], 0);
    }
}