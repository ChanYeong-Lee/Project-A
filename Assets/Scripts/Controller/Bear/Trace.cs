using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class TraceState : BearState
    {
        public TraceState(Creature owner) : base(owner) { }
        
        public override void Enter()
        {
            attackCooldown = bear.Data.AttackCooldown;
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
            
            // ���� ����
            FixedHorizontal(bear.traceAngle);
            
            MoreSpeed();
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.fixedDeltaTime));
        }

        public override void Transition()
        {
            // if (distanceToTarget < bear.Data.AttackRange && attackCooldown < 0) 
            //     ChangeState(State.Attack);
            
            // if (distanceToTarget > 100) 
            //     ChangeState(State.Patrol);
            
        }
    }
}