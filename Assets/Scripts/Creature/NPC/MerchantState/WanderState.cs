using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class WanderState : MerchantState
    {

        public WanderState(Creature owner) : base(owner) { }
        public override void Enter()
        {
            Debug.Log("WanderState Enter");
            Owner.state = State.Wander;
            Owner.RoamingAround();

        }
        public override void Update()
        {
            CheckInteractibleObj();
        }
        public override void Transition()
        {

        }
        public void EnemyCheck()
        {

        }
        public void CheckInteractibleObj()
        {
            if (Owner.cols.Count() == 0) return;
            foreach (Collider col in Owner.cols)
            {
                if (col.gameObject.layer == LayerMask.NameToLayer("Player") /*9 PlayerLayer*/)
                {
                    //Owner.StopMoving();
                    Owner.target = col.gameObject;
                    ChangeState(State.Idle);
                }
                else if (col.gameObject.layer == LayerMask.NameToLayer("Enemy") /*6 EnemyLayer*/)
                {
                    Owner.StopMoving();
                    Owner.target = col.gameObject;
                    ChangeState(State.RunAway);
                }
            }
        }
    }
}