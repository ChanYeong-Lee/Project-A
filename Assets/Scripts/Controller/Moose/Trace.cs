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
            vertical = distanceToTarget / 2 > 3 ? 3 : distanceToTarget / 2;

            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
            
            FixedHorizontal(30);
        }

        public override void Transition()
        {
            if (Vector3.Distance(target.transform.position, moose.transform.position) < 5 && attackCooldown < 0.0f) 
                ChangeState(State.Attack);
            
            if (Vector3.Distance(target.transform.position, moose.transform.position) > 100) 
                ChangeState(State.Patrol);
        }
    }

}