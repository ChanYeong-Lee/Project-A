using System.Collections.Generic;
using UnityEngine;

public abstract class Monster : Creature, IFarmable
{
    [SerializeField] protected DropTableData dropItem;
    
    public DropTableData DropItem => dropItem;


    public override void Init()
    {
        base.Init();
    }


    public Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType)
    {
        farmingType = dropItem.FarmingType;
        
        return null;
    }
}