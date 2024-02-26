using System.Collections.Generic;
using UnityEngine;

public abstract class Monster : Creature, IFarmable
{
    protected MonsterData monsterData;
    protected GameObject target;

    // 스폰 위치 -

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

    protected class MonsterState : CreatureState
    {
        protected GameObject target;
        
        public MonsterState(Creature owner) : base(owner)
        {
        }
    }
}