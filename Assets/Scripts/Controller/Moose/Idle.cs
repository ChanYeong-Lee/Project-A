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
            if (target is not null && isUnderAttack) 
                ChangeState(State.Attack);
            
            if (!moose.MonsterData.IsAggressive && distanceToTarget < moose.MonsterData.ViewDistance) 
                ChangeState(State.Run);
            
            if (moose.MonsterData.IsAggressive && distanceToTarget < moose.MonsterData.TrackingDistance) 
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