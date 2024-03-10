using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class InteractState : MerchantState
    {
     
        public InteractState(Creature owner) : base(owner) { }
       
        public override void Enter()
        {
            Debug.Log("InteractState Enter");
            Owner.state = State.Interact;
        }
        public override void Update()
        {
            //TODO: Merge �Ŀ� FŰ�� ��ȣ�ۿ�. TestScript���� �����ֱ�
            //if (Input.GetKeyDown("b"))
            //{
            //    pressed = !pressed;
            //    if (true == pressed)
            //    {
            //        Open();
            //    }
            //    if (false == pressed)
            //    {
            //        Close();
            //    }

            //}
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
            if(distance > 2.5f)
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
