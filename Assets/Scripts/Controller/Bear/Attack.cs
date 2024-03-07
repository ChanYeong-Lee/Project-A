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
            
            // FixedHorizontal(30, 1);

            if (isChangedState) 
                return;
            
            if (angleToTarget is < 30 and > -30)
            {
                anim.SetInteger("IDInt", idInt);
                anim.SetBool("Attack", true);
            }
        }

        public override void Transition()
        {
            if (target == null)
                ChangeState(State.Idle);
            
            // TODO : Return 상태 추가하면 바꾸기
            if (distanceToTarget > bear.Data.TrackingDistance) 
                ChangeState(State.Idle);

            if(isChangedState || distanceToTarget > bear.Data.AttackRange) 
                ChangeState(State.Trace);
        }

        public override void Exit()
        {
            attackCooldown = bear.Data.AttackCooldown;
            anim.SetBool("Attack", false);
        }
    }
}