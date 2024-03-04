using UnityEngine;
using State = Define.MooseState;

namespace MooseController
{
    public class IdleState : MooseState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            // 인스펙터 확인용 코드
            moose.state = State.Idle;

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
            
            if (!moose.Data.IsAggressive && distanceToTarget < moose.Data.ViewDistance) 
                ChangeState(State.Run);
            
            if (moose.Data.IsAggressive && distanceToTarget < moose.Data.TrackingDistance) 
                ChangeState(State.Trace);
                    
            if (isChangedState) 
                ChangeState(State.Patrol);
        }

        public override void Exit()
        {
            anim.SetBool("Stand", false);
        }
    }
}