using System.Collections.Generic;
using UnityEngine;

public abstract class Monster : Creature, IFarmable
{
    [SerializeField] protected DropTableData dropItem;
    [SerializeField] protected float farmingTime;
    
    public DropTableData DropItem => dropItem;
    public float FarmingTime { get => farmingTime; set => farmingTime = value; }
    
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