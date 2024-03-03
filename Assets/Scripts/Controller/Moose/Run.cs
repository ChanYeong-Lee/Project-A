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

            // TODO : �� ���� Ȱ���ϸ� �浹 �˻� �� ȸ����Ű�� �̵��ϱ� ����Ҽ���?
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
            if (target is null || distanceToTarget > moose.Data.TrackingDistance)
            {
                ChangeState(State.Idle);
            }
        }
    }

}