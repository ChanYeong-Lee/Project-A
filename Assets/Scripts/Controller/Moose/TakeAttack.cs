using UnityEngine;
using State = Define.MooseState;

namespace MooseController
{
    public class TakeAttackState : MooseState
    {
        public TakeAttackState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            anim.SetBool("Damaged", true);
        }

        public override void Update()
        {
            base.Update();
            
            // TODO : ����� �޴� ����
            
        }

        public override void Transition()
        {
            ChangeState(Vector3.Distance(target.transform.position, moose.transform.position) < 3
                ? State.Attack
                : State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Damaged", false);
        }
    }

}