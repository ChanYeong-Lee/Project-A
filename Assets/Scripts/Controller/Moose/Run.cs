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

        public override void Update()
        {
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
            anim.SetFloat("Horizontal",
                Vector3.Dot(moose.transform.forward, moose.transform.position - target.transform.position) < 0
                    ? Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.deltaTime)
                    : Mathf.Lerp(anim.GetFloat("Horizontal"), 0, Time.deltaTime));
        }

        public override void Transition()
        {
            if (target is null || Vector3.Distance(target.transform.position, moose.transform.position) > 100)
            {
                ChangeState(State.Idle);
            }
        }
    }

}