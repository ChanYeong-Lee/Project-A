using CreatureController;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using NpcController;
using System.Buffers;

namespace MerchantController 
{
public class MerchantState : NPCState
    {
        public Merchant Owner => base.owner as Merchant;
        
        public MerchantState(Creature owner) : base(owner)
        { 
        
        }
    }
}