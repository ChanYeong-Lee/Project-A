using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.UI.GridLayoutGroup;
using State = Define.MerchantState;

namespace MerchantController
{
    public class IdleState : MerchantState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Owner.state = State.Idle;
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