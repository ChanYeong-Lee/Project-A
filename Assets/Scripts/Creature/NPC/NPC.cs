using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CreatureController;

public abstract class NPC : Creature
{
    protected NPCData npcData;
    public GameObject target;

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
        public GameObject target;
        public NPCState(Creature owner) : base(owner)
        {

        }
    }
}
