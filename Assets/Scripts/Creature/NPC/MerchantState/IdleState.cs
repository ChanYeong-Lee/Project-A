using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static UnityEngine.UI.GridLayoutGroup;
using State = Define.MerchantState;

namespace MerchantController
{
    public class IdleState : MerchantState
    {
        float waitDelay = 2.5f;
        float literalDelay = 2.5f;
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Debug.Log("IdleState Enter");
            Owner.state = State.Idle;
            Owner.StopMoving();
        }

        public override void Update()
        {
            waitDelay -= Time.deltaTime;
            if (waitDelay <= 0)
            {
                waitDelay = literalDelay;
                CheckAround();
            }
        }
        public override void Exit()
        {

        }

        public void CheckAround()
        {

            if (Owner.cols.Count() == 0) 
            {
                ChangeState(State.Wander);
                return;
            }
            foreach (Collider col in Owner.cols)
            {
                if (col.gameObject.layer == LayerMask.NameToLayer("Player") /*9 PlayerLayer*/)
                {
                    //TODO: Look at Player Ãß°¡
                    Owner.target = col.gameObject;
                    Owner.StopMoving();
                }
                else if (col.gameObject.layer == LayerMask.NameToLayer("Enemy") /*6 EnemyLayer*/)
                {
                    Owner.target = col.gameObject;
                    ChangeState(State.RunAway);
                }
            }
        }
       
        private void OnCollisionEnter(Collision collision)
        {
            if (collision.gameObject.layer == LayerMask.NameToLayer("Player"))
            {
                Owner.SwitchAnimation(State.Idle);
                ChangeState(State.Interact);
            }
        }


    }
}