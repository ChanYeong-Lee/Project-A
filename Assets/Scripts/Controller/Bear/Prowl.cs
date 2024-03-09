using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class ProwlState : BearState
    {
        public ProwlState(Creature owner) : base(owner) { }

        private float prowlTime = 0.0f;

        public override void Enter()
        {
            bear.state = State.Prowl;
            prowlTime = Random.Range(2.0f, 7.0f);
            ChangeDirectMode(DirectMode.Manual);

            velocity = Random.Range(2.0f, 3.0f);
        }

        public override void Update()
        { 
            base.Update();

            bear.Agent.SetDestination(bear.MoveTarget.position);
            prowlTime -= Time.deltaTime;
         
            angularVelocity = horizontal < 0.0f ? vertical - 1.0f : Mathf.Clamp(1.0f - vertical, 0.0f, 1.0f);
        }

        public override void Exit()
        {
            bear.lastState = State.Prowl;
        }

        public override void Transition()
        {
            AttackTransition();

            if (prowlTime < 0.0f)
            {
                ChangeState(State.Think);
            }
        }
    }
}