using System.Collections.Generic;
using UnityEngine;

public abstract class Monster : Creature, IFarmable
{
    private MonsterData monsterData;
    
    public override void Init()
    {
        base.Init();
        monsterData = creatureData as MonsterData;
    }

    public Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType)
    {
        farmingType = monsterData.DropItem.FarmingType;
        
        return null;
    }
}