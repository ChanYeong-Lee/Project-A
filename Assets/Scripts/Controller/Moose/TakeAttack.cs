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

            // moose.CurrentStat.HealthPoint -= target.
            
            moose.state = State.TakeAttack;
            Debug.Log($"TakeAttack {moose.CurrentStat.HealthPoint}");
        }

        public override void Transition()
        {
            if (moose.CurrentStat.HealthPoint <= 0) 
                ChangeState(State.Dead);
            
            ChangeState(distanceToTarget < moose.MonsterData.AttackRange ? State.Attack : State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Damaged", false);
            // isUnderAttack = false;
        }
    }

}