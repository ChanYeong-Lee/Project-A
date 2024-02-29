using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class InteractState : MerchantState
    {
        public InteractState(Creature owner) : base(owner) { }

        public override void Update()
        {

        }

        public override void Transition()
        {
            ChangeState(State.Interact);

        }
    }
}
