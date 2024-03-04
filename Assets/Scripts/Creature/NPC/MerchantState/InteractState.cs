using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class InteractState : MerchantState
    {
        public InteractState(Creature owner) : base(owner) { }
        //TODO: �׽�Ʈ�����δ� Player�� target���� ������ ���¿��� Distance�� Ư�� ������ ������ ���º����ϵ��� ����
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

       //TODO: Idle ���·� ��ȯ�ϴ� ����
       //TODO: ����Ʈ, ��ȭ, ����


    }
}
