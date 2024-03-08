using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class RushState : BearState
    {
        private float rushTime = 5.0f;
        
        public RushState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            bear.state = State.Rush;
            rushTime = 5.0f;

            StartMove();
            velocity = 0.0f;
            ChangeDirectMode(DirectMode.FastDirection);

            SetMoveTargetPos(target.position + target.forward * 10.0f);
        }


        public override void Update()
        {
            base.Update();
            rushTime -= Time.deltaTime;
            Debug.Log($"Rush : {rushCooldown}");
            if (Mathf.Abs(angleToTarget) < 10.0f)
            {
                velocity = 3.0f;
                SetMoveTargetPos(bear.transform.forward * 10.0f);
            }
        }

        public override void Exit()
        {
            rushCooldown = 10.0f;
        }

        public override void Transition()
        {
            if (rushTime < 0.0f)
            {
                ChangeState(State.Trace);
            }
        }
    }
}