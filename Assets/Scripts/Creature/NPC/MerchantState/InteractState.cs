using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class InteractState : MerchantState
    {
        private bool isToggle = false;
        public InteractState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Debug.Log("InteractState Enter");
            Owner.state = State.Interact;
            Open();
        }
        public override void Update()
        {
            if (Managers.Input.IsInteracting)
            {
                isToggle = !isToggle;
                if (true == isToggle)
                {
                    Open();
                }
               

            }
        }

        public override void Transition()
        {
            CheckProximityTarget();
        }

        //TODO: Idle ���·� ��ȯ�ϴ� ����
        //TODO: ����Ʈ, ��ȭ, ����

        private void CheckProximityTarget()
        {
            float distance = Vector3.Distance(Owner.transform.position, Owner.target.transform.position);
            if (distance > 2.5f)
            {
                ChangeState(State.Idle);
            }
        }
        public void Open()
        {

            Managers.UI.OpenDialogUI();
        }
        public void press()
        {

        }
        public void Close()
        {
            Managers.UI.CloseMainUI();
        }

    }
}
