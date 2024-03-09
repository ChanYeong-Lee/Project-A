using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class ProwlState : BearState
    {
        public ProwlState(Creature owner) : base(owner) { }

        private float prowlTime = 5.0f;
        private float prowlTimeDelta = 0.0f;
        public override void Enter()
        {
            bear.state = State.Prowl;
            prowlTimeDelta = prowlTime;
            ChangeDirectMode(DirectMode.Manual);
        }
        public override void Update()
        { 
            base.Update();
            
            bear.Agent.SetDestination(bear.MoveTarget.position);

            prowlTimeDelta -= Time.deltaTime;

            velocity = 3.0f;
            angularVelocity = vertical < -1.0f ? vertical + 3.0f : vertical - 1.0f;
        }

        public override void Transition()
        {
            if (prowlTimeDelta < 0.0f)
            {
                ChangeState(State.Rush);
            }
        }
    }
}