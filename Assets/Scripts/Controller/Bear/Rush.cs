using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class RushState : BearState
    {
        private float rushTime = 30.0f;
        private float rushTimeDelta = 0.0f;
        
        public RushState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            bear.state = State.Rush;

            rushTimeDelta = rushTime;
            ChangeDirectMode(DirectMode.Auto);
            velocity = 3.0f;

            Vector3 dir = bear.MoveTarget.position - bear.transform.position;
            dir.Normalize();
            bear.Agent.SetDestination(bear.MoveTarget.position + dir * 20.0f);
        }


        public override void Update()
        {
            base.Update();
            rushTimeDelta -= Time.deltaTime;
            if (Mathf.Abs(horizontal) < 0.2f)
            {

            }
        }

        public override void Exit()
        {
        }

        public override void Transition()
        {
            //if (rushTimeDelta < 0.0f)
            //{
            //    ChangeState(State.Prowl);
            //}
            if (bear.Agent.hasPath == false)
            {
                ChangeState(State.Prowl);
            }
        }
    }
}