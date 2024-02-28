using UnityEngine;
using State = Define.MooseState;

namespace MooseController
{
    public class TraceState : MooseState
    {
        public TraceState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            attackCooldown = moose.MonsterData.AttackCooldown;
            moose.state = State.Trace;
        }

        public override void Update()
        {
            base.Update();

            // 거리에 따른 속도값 조절 필요
            if (distanceToTarget > moose.MonsterData.AttackRange)
                vertical = 3;
            else if (distanceToTarget > moose.MonsterData.AttackRange / 2)
                vertical = distanceToTarget / 2;
            else
                vertical = 0;
        }

        public override void FixedUpdate()
        {
            FixedHorizontal(30);
            
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
        }

        public override void Transition()
        {
            if (distanceToTarget < moose.MonsterData.AttackRange && attackCooldown < 0) 
                ChangeState(State.Attack);
            
            if (distanceToTarget > 100) 
                ChangeState(State.Patrol);
        }
    }

}