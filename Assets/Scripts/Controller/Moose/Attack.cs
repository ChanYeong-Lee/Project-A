using UnityEngine;
using State = Define.MooseState;

namespace MooseController
{
    public class AttackState : MooseState
    {
        public AttackState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            isChangedState = false;
            
            Debug.Log("attack");
            moose.state = State.Attack;
        }

        public override void Update()
        {
            base.Update();
        }

        public override void FixedUpdate()
        {
            if (anim.GetBool("Attack")) 
                isChangedState = true;
            
            FixedHorizontal(30, 1);

            if (isChangedState) 
                return;
            
            if (angleToTarget is < 30 and > -30)
            {
                anim.SetInteger("IDInt", idInt);
                anim.SetBool("Attack", true);
                Debug.Log($"id int = {idInt}, anim Attack = {anim.GetBool("Attack")}, attack motion");
            }
            else if (angleToTarget is > 150 or < -150)
            {
                anim.SetBool("Attack", true);
                anim.SetInteger("IDInt", 4);
                Debug.Log("back attack");
            }
            // TODO : 공격 로직
        }

        public override void Transition()
        {
            if (target == null)
                ChangeState(State.Idle);
            
            if (distanceToTarget > 100) 
                ChangeState(State.Patrol);

            if(isChangedState || distanceToTarget > 5) 
                ChangeState(State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Attack", false);
        }
    }
}