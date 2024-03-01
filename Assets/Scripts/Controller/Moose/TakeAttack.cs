using UnityEngine;
using State = Define.MooseState;

namespace MooseController
{
    public class TakeAttackState : MooseState
    {
        public TakeAttackState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            isUnderAttack = true;
            anim.SetBool("Damaged", true);
        }

        public override void Update()
        {
            base.Update();
            
            // TODO : 대미지 받는 로직
            
        }

        public override void Transition()
        {
            ChangeState(distanceToTarget < 5 ? State.Attack : State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Damaged", false);
        }
    }

}