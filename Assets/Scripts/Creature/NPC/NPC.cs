using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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

    protected class NPCState : CreatureState
    {
        protected GameObject target;
        public NPCState(Creature owner) : base(owner)
        {
        }

       
    }

}
