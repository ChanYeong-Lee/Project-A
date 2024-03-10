using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class TraceState : BearState
    {
        public TraceState(Creature owner) : base(owner) { }

        private float traceTime = 0.0f;

        public override void Enter()
        {
            bear.state = State.Trace;
            ChangeDirectMode(DirectMode.Auto);
            traceTime = Random.Range(5.0f, 10.0f);
            velocity = 3.0f;
        }

        public override void Update()
        {
            base.Update();
            bear.Agent.SetDestination(bear.MoveTarget.position);
        }

        public override void Exit()
        {
            bear.lastState = State.Trace;
        }

        public override void Transition()
        {
            AttackTransition();

            if (traceTime < 0.0f)
            {
                ChangeState(State.Think);
            }
        }
    }
}