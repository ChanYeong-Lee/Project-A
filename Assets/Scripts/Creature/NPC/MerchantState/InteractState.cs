using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class InteractState : MerchantState
    {
        public InteractState(Creature owner) : base(owner) { }
        //TODO: 테스트용으로는 Player가 target으로 지정된 상태에서 collisionEnter시에만 상태변경하도록 구현
        public override void Enter()
        {
            Debug.Log("InteractState Enter");
            Owner.state = State.Interact;
        }
        public override void Update()
        {

        }

        public override void Transition()
        {

        }

       


    }
}
