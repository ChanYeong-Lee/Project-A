using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class InteractState : MerchantState
    {
        public InteractState(Creature owner) : base(owner) { }
        //TODO: 테스트용으로는 Player가 target으로 지정된 상태에서 Distance가 특정 값보다 작을때 상태변경하도록 구현
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

       //TODO: Idle 상태로 전환하는 조건
       //TODO: 퀘스트, 대화, 상점


    }
}
