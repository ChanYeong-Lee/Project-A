using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class AttackState : BearState
    {
        public AttackState(Creature owner) : base(owner) { }
        
        public override void Enter()
        {
            isChangedState = false;
            
            Debug.Log("attack");
            bear.state = State.Attack;
        }

        public override void Update()
        {
            base.Update();
            
            // TODO : 공격 로직

        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            
            if (anim.GetBool("Attack")) 
                isChangedState = true;
            
            FixedHorizontal(30, 1);

            if (isChangedState) 
                return;
            
            if (angleToTarget is < 30 and > -30)
            {
                anim.SetInteger("IDInt", idInt);
                anim.SetBool("Attack", true);
            }
            else if (angleToTarget is > 150 or < -150)
            {
                anim.SetBool("Attack", true);
                anim.SetInteger("IDInt", 4);
                Debug.Log("back attack");
            }
        }

        public override void Transition()
        {
            if (target is null)
                ChangeState(State.Idle);
            
            // TODO : Return 상태 추가하면 바꾸기
            // if (distanceToTarget > bear.Data.TrackingDistance) 
            //     ChangeState(State.Patrol);
            if (distanceToTarget > bear.Data.TrackingDistance) 
                ChangeState(State.Idle);

            if(isChangedState || distanceToTarget > bear.Data.AttackRange) 
                ChangeState(State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Attack", false);
        }
    }
}