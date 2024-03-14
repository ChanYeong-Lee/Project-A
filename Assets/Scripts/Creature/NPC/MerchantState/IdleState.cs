using System;
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
            Owner.DisableAgentMovement();
           
        }

        public override void Update()
        {
            waitDelay -= Time.deltaTime;
            if (waitDelay <= 0)
            {
                waitDelay = literalDelay;
                LookForNearbyTargets();
            }
            if (Owner.target != null && Owner.target.layer == LayerMask.NameToLayer("Player"))
            {
                CheckProximityAndChangeState();
            }
        }
        public override void Exit()
        {
            
        }

        public void LookForNearbyTargets()
        {
          
            //TODO: NPC, Player, Enemy, �׸��� collectibleObject�� ���� ó��
            if (Owner.nearbyColliders.Count() == 0 || Owner.nearbyColliders.Contains(null))
            {
                
                ChangeState(State.Wander);
                return;
            }
            foreach (Collider col in Owner.nearbyColliders)
            {
                Debug.Log($"���̾� �� : {col.gameObject.layer}");
                switch (col.gameObject.layer)
                {
                    case 9:
                    //LayerMask.NameToLayer("Player"):
                        //TODO: Look at Player �߰�
                        Owner.target = col.gameObject;
                        Owner.DisableAgentMovement();
                        break;
                    case 6:
                        Owner.target = col.gameObject;
                        ChangeState(State.RunAway);
                        break;


                }

                //if (col.gameObject.layer == LayerMask.NameToLayer("Player") /*9 PlayerLayer*/)
                //{
                //    //TODO: Look at Player �߰�
                //    Owner.target = col.gameObject;
                //    Owner.DisableAgentMovement();
                //}
                //else if (col.gameObject.layer == LayerMask.NameToLayer("Enemy") /*6 EnemyLayer*/)
                //{
                //    Owner.target = col.gameObject;
                //    ChangeState(State.RunAway);
                //}
            }
            
        }
        public void CheckProximityAndChangeState()
        {
            if (!Managers.Input.IsInteracting)
                return;
            
            float distance = Vector3.Distance(Owner.transform.position, Owner.target.transform.position);
            if (distance <= 2.5f)
            {
                ChangeState(State.Interact);
            }
        }

        

    }
}