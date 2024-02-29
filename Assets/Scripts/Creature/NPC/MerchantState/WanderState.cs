using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class WanderState : MerchantState
    {

        public WanderState(Creature owner) : base(owner) { }
        public override void Enter()
        {
            Owner.state = State.Wander;
            Owner.RoamingAround();
            
        }
        public override void Update()
        {
            CheckInteractibleArea();
        }
        public override void Transition()
        {
           
        }
        public void EnemyCheck()
        {

        }
        public void CheckInteractibleArea()
        {

            Collider[] cols = Physics.OverlapBox(Owner.transform.position + Owner.transform.up,
                Owner.overlapBoxSize * 0.5f, Owner.transform.rotation,
                Owner.Interactable);
            foreach (Collider col in cols)
            {  
                if (col.gameObject.layer == LayerMask.NameToLayer("Player") /*9 PlayerLayer*/)
                {
                    Debug.Log(col.name);
                    Owner.StopMoving();
                    ChangeState(State.Interact);
                }
                else if (col.gameObject.layer == LayerMask.NameToLayer("Enemy") /*6 EnemyLayer*/)
                {
                    Debug.Log(col.name);
                    Owner.StopMoving();
                    ChangeState(State.RunAway);
                }
            }
        }
    }
}