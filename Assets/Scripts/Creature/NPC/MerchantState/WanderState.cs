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
            Owner.BeginWandering();

        }
        public override void Update()
        {
            HandleNearbyObjects();
        }
        public override void Transition()
        {

        }
        public void EnemyCheck()
        {

        }
        public void HandleNearbyObjects()
        {
            if (Owner.nearbyColliders.Count() == 0) return;
            foreach (Collider col in Owner.nearbyColliders)
            {
                if (col.gameObject.layer == LayerMask.NameToLayer("Player") /*9 PlayerLayer*/)
                {
                    //Owner.StopMoving();
                    Owner.target = col.gameObject;
                    ChangeState(State.Idle);
                }
                else if (col.gameObject.layer == LayerMask.NameToLayer("Enemy") /*6 EnemyLayer*/)
                {
                    Owner.DisableAgentMovement();
                    Owner.target = col.gameObject;
                    ChangeState(State.RunAway);
                }
            }
        }
    }
}