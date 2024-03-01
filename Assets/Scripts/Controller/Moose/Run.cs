using UnityEngine;
using State = Define.MooseState;

namespace MooseController
{
    public class RunState : MooseState
    {
        public RunState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            vertical = 3;

            moose.state = State.Run;
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.fixedDeltaTime));

            // TODO : 이 로직 활용하면 충돌 검사 후 회전시키고 이동하기 기능할수도?
            switch (angleToTarget)
            {
                case < 90 and > 0:
                    anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.fixedDeltaTime));
                    break;
                case > -90 and < 0:
                    anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), 2, Time.fixedDeltaTime));
                    break;
                default:
                    anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), 0, Time.fixedDeltaTime));
                    break;
            }
        }

        public override void Transition()
        {
            if (target is null || distanceToTarget > moose.MonsterData.TrackingDistance)
            {
                ChangeState(State.Idle);
            }
        }
    }

}