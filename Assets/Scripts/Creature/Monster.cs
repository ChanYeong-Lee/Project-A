using System.Collections.Generic;
using UnityEngine;

public abstract class Monster : Creature, IFarmable
{
    protected MonsterData monsterData;
    [SerializeField]
    protected Transform target;

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
        protected Monster monster => owner as Monster;
        protected Transform target => monster.target;
        
        public MonsterState(Creature owner) : base(owner)
        {
        }
    }
}