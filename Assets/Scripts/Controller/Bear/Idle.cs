using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class IdleState : BearState
    {
        public IdleState(Creature owner) : base(owner) { }
        public override void Enter()
        {
            // 인스펙터 확인용 코드
            bear.state = State.Idle;

            RandVariable(1f, 5f, 0);
            anim.SetBool("Stand", true);
            Debug.Log("IDLE");
        }
        
        public override void Update()
        {
            base.Update();

            anim.SetInteger("IDInt", idInt);
            
            
            if (randTime < 0) 
                RandVariable(1f,2f, 0.9f);
        }

        public override void Transition()
        {
            // if (isUnderAttack) 
            //     ChangeState(State.TakeAttack);
            
            // if (!bear.Data.IsAggressive && distanceToTarget < bear.Data.ViewDistance) 
            //     ChangeState(State.Run);
            
            if (bear.Data.IsAggressive && distanceToTarget < bear.Data.TrackingDistance) 
                ChangeState(State.Trace);
                    
            // if (isChangedState) 
            //     ChangeState(State.Patrol);
        }

        public override void Exit()
        {
            anim.SetBool("Stand", false);
        }
    }
}