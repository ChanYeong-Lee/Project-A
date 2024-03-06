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

            monster.CurrentStat.HealthPoint -= moose.ReceivedDamage;   
            
            moose.state = State.TakeAttack;
            Debug.Log($"hp : {moose.CurrentStat.HealthPoint}, ReceivedDamage : {moose.ReceivedDamage}");
        }

        public override void Transition()
        {
            if (moose.CurrentStat.HealthPoint <= 0) 
                ChangeState(State.Dead);
            else
                ChangeState(distanceToTarget < moose.Data.AttackRange ? State.Attack : State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Damaged", false);
            // isUnderAttack = false;
        }
    }

}