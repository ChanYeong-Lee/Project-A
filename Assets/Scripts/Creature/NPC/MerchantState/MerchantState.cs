using CreatureController;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using NpcController;

namespace MerchantController 
{
public class MerchantState : NPCState
    {
        public Merchant Owner => base.owner as Merchant;
        protected float CurSpeed
        {
            get { return Owner.CurSpeed; }
            set { Owner.CurSpeed = value; }
        }

        public MerchantState(Creature owner) : base(owner) { }
    }
}