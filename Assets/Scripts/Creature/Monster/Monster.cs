using System.Collections.Generic;
using UnityEngine;
using CreatureController;

public abstract class Monster : Creature, IFarmable
{
    protected MonsterData monsterData;
    [SerializeField] protected Transform target;
    
    public MonsterData MonsterData => monsterData;
    public Transform Target { get => target; set => target = value; }

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

// MonsterState도 길어지면 새 스크립트로 분리
namespace MonsterController
{
    public class MonsterState : CreatureState
    {
        protected Monster monster => owner as Monster;
        protected Transform target => monster.Target;
            
        public MonsterState(Creature owner) : base(owner) { }
    }

    public class AttackState : MonsterState
    {
        public AttackState(Creature owner) : base(owner)
        {
        }
    }
}