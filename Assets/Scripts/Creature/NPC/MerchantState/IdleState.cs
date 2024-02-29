using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class IdleState : MerchantState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            ChangeState(State.Wander);


        }
        public override void Transition()
        {

        }
        public override void Exit()
        {

        }
    }
}