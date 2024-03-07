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

            // �Ÿ��� ���� �ӵ��� ���� �ʿ�
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
            
            // ���� ����
            bear.traceAngle = 30;
            FixedHorizontal(30);
            MoreSpeed(false);
            
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.fixedDeltaTime));
        }

        public override void Transition()
        {
            if (bear.CurrentStat.HealthPoint < bear.Data.Stats[bear.CurrentLevel].HealthPoint / 2)
            {
                // �ǿ� ���� ���� ��ȭ
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

                // ���� ���� �ð�
                randTime = Random.Range(1f, 2f);
            }
            
            if (distanceToTarget < bear.Data.AttackRange && attackCooldown < 0) 
                ChangeState(State.Attack);
        }
    }
}