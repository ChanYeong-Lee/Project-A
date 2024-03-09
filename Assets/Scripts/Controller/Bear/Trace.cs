using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class TraceState : BearState
    {
        public TraceState(Creature owner) : base(owner) { }
        
        public override void Enter()
        {
            bear.state = State.Trace;

            velocity = 2.0f;
            ChangeDirectMode(DirectMode.Manual);
        }

        public override void Update()
        {
            base.Update();
            SetMoveTargetPos(target.position);

            // 거리에 따른 속도값 조절 필요
            //if (distanceToTarget > bear.Data.AttackRange)
            //    velocity = 3.0f;
            //else if (distanceToTarget > bear.Data.AttackRange / 2)
            //    velocity = distanceToTarget / 2;
            //else
            //    velocity = 0;
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

        }

        public override void Transition()
        {
            //if (distanceToTarget < bear.Data.AttackRange && attackCooldown < 0) 
            //    ChangeState(State.Attack);
        }
    }
}