using CreatureController;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace MerchantController 
{
public class MerchantState : NPCState
    {
        public Merchant Owner => base.owner as Merchant;
       
        protected GameObject Target
        {
            get { return Owner.target; }
            set { Owner.target = value; }
        }

        public MerchantState(Creature owner) : base(owner) { }
    }
}