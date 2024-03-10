using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class DeadState : BearState
    {
        public DeadState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            bear.state = State.Dead;
            

            anim.CrossFade("Dead", 0.2f);

            ChangeDirectMode(DirectMode.Manual);
            velocity = 0.0f;
            angularVelocity = 0.0f;
            GameEventsManager.Instance.miscEvents.onKillCount += KillCount;
        }

        private void KillCount(int count)
        {
            count = 1;
        }
    }
}