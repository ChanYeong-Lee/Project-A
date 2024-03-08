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
            //TODO: NPC, Player, Enemy, 그리고 collectibleObject에 대한 처리
            if (Owner.nearbyColliders.Count() == 0)
            {
                ChangeState(State.Wander);
                return;
            }
            foreach (Collider col in Owner.nearbyColliders)
            {
                if (col.gameObject.layer == LayerMask.NameToLayer("Player") /*9 PlayerLayer*/)
                {
                    //TODO: Look at Player 추가
                    Owner.target = col.gameObject;
                    Owner.DisableAgentMovement();
                }
                else if (col.gameObject.layer == LayerMask.NameToLayer("Enemy") /*6 EnemyLayer*/)
                {
                    Owner.target = col.gameObject;
                    ChangeState(State.RunAway);
                }
            }
            /* 수정이 가능하다면 위 조건과 대체
             if (Owner.nearbyColliders.Count() == 0) 
  {
      ChangeState(State.Wander);
      return;
  }

  foreach (Collider col in Owner.nearbyColliders)
  {
      switch (col.gameObject.layer)
      {
          case LayerMask.NameToLayer("Player"):
              // TODO: Look at Player 추가
              Owner.target = col.gameObject;
              Owner.DisableAgentMovement();
              break;
          case LayerMask.NameToLayer("Enemy"):
              Owner.target = col.gameObject;
              ChangeState(State.RunAway);
              break;
          // 다른 레이어에 대한 추가적인 case를 필요에 따라 추가하세요.
      }
  }
             */
        }
        public void CheckProximityAndChangeState()
        {
            if (!Managers.Game.Player.GetComponent<CharacterInteraction>().Interaction)
                return;
            
            float distance = Vector3.Distance(Owner.transform.position, Owner.target.transform.position);
            if (distance <= 2.5f)
            {
                ChangeState(State.Interact);
            }
        }

        

    }
}