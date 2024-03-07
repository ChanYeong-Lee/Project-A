using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class PowerTraceState : BearState
    {
        private float powerTraceTime;
        
        public PowerTraceState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            powerTraceTime = 20f;
            bear.state = State.PowerTrace;
        }

        public override void Update()
        {
            base.Update();
            
            // 거리에 따른 속도값 조절 필요
            if (distanceToTarget > bear.Data.AttackRange)
                vertical = 3.0f;
            else if (distanceToTarget > bear.Data.AttackRange / 2)
                vertical = distanceToTarget / 2;
            else
                vertical = 0;
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (false == canMove)
                return;
            
            bear.traceAngle = 30;
            FixedHorizontal(30);
            MoreSpeed();
            
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.fixedDeltaTime));
        }
    }
}