using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class IdleState : BearState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            bear.state = State.Idle;
            StopMove();
        }
        
        public override void Update()
        {
            base.Update();
            Debug.Log($"Idle = rush : {rushCooldown}");
            // if (randTime < 0) 
            //     RandVariable(1f,2f, 0.9f);
        }

        public override void Transition()
        {
            if (target != null)
            {
                ChangeState(State.Trace);
            }
        }
    }
}