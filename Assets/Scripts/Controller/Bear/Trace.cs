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
            
            // 각도 조절
            bear.traceAngle = 30;
            FixedHorizontal(30);
            MoreSpeed(false);
            
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.fixedDeltaTime));
        }

        public override void Transition()
        {
            if (bear.CurrentStat.HealthPoint < bear.Data.Stats[bear.CurrentLevel].HealthPoint / 2)
            {
                // 피에 따른 상태 변화
            }

            if (randTime < 0)
            {
                State randState = (State)Random.Range(0, (int)State.Dead);
                switch (randState)
                {
                    case State.PowerTrace:
                        ChangeState(State.PowerTrace);
                        break;
                    case State.Rush:
                        if (rushCooldown < 0)
                        {
                            ChangeState(State.Rush);
                        }
                        break;
                    // case State.Prowl:
                    //     ChangeState(State.Prowl);
                    //     break;
                }

                // 상태 유지 시간
                randTime = Random.Range(1f, 2f);
            }
            
            if (distanceToTarget < bear.Data.AttackRange && attackCooldown < 0) 
                ChangeState(State.Attack);
        }
    }
}