using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class TakeAttackState : BearState
    {
        public TakeAttackState(Creature owner) : base(owner) { }
        
        public override void Enter()
        {
            anim.SetBool("Damaged", true);

            monster.CurrentStat.HealthPoint -= bear.ReceivedDamage;   
            
            bear.state = State.TakeAttack;
            Debug.Log($"hp : {bear.CurrentStat.HealthPoint}, ReceivedDamage : {bear.ReceivedDamage}");
        }

        public override void Transition()
        {
            if (bear.CurrentStat.HealthPoint <= 0) 
                ChangeState(State.Dead);
            
            ChangeState(distanceToTarget < bear.Data.AttackRange ? State.Attack : State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Damaged", false);
            // isUnderAttack = false;
        }
    }
}