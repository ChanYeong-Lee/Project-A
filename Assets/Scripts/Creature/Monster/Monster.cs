using System.Collections.Generic;
using UnityEngine;
using CreatureController;

public abstract class Monster : Creature, IFarmable
{
    protected MonsterData data;
    [SerializeField] protected Transform target;
    [SerializeField] protected bool isFarmable;
    
    public MonsterData Data => data;
    public Transform Target { get => target; set => target = value; }
    public bool IsFarmable { get => isFarmable; set => isFarmable = value; }

    public override void Init()
    {
        base.Init();
        data = creatureData as MonsterData;
    }

    public Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType)
    {
        farmingType = Define.FarmingType.None;

        if (!isFarmable)
            return null;

        if (data.DropItem == null)
            return null;
        
        farmingType = data.DropItem.FarmingType;

        return data.DropItem.GetDropItem();
    }
}

// MonsterState도 길어지면 새 스크립트로 분리
namespace MonsterController
{
    public class MonsterState : CreatureState
    {
        protected Monster monster => owner as Monster;
        protected Transform target => monster.Target;
            
        public MonsterState(Creature owner) : base(owner) { }
    }
}