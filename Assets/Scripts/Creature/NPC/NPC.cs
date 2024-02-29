using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CreatureController;

public abstract class NPC : Creature
{
    protected NPCData npcData;
    protected GameObject target;

    [SerializeField] protected float moveSpeed;
    [SerializeField] protected float sprintSpeed;
    [SerializeField] protected float curSpeed;

    public float CurSpeed { get => curSpeed; set => curSpeed = value; }

    public override void Init()
    {
        base.Init();
        npcData = creatureData as NPCData;
    }
 
    void Update()
    {
        
    }
}

namespace NpcController
{
    public class NPCState : CreatureState
    {
        protected GameObject target;
        public NPCState(Creature owner) : base(owner)
        {

        }
    }
}
