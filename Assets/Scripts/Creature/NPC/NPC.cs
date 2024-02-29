using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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

namespace CreatureController
{
    public class NPCState : CreatureState
    {
        public GameObject target;
        public NPCState(Creature owner) : base(owner)
        {

        }
    }
}
