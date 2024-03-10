using UnityEngine;
using State = Define.MooseState;

namespace MooseController
{
    public class AttackState : MooseState
    {
        private int count;
        public AttackState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            isChangedState = false;
            count = 0;
            Debug.Log("attack");
            moose.state = State.Attack;
        }

        public override void Update()
        {
            base.Update();

            // TODO : 공격 로직
            var overlapBox = Physics.OverlapBox(moose.Eyes.transform.position, new Vector3(moose.Data.AttackRange / 2, moose.Data.AttackRange / 2, moose.Data.AttackRange / 2));

            foreach (Collider collider in overlapBox)
            {
                if (collider.gameObject.layer == LayerMask.NameToLayer("Player"))
                {
                    count = 1;
                }
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            
            if (anim.GetBool("Attack")) 
                isChangedState = true;
            
            FixedHorizontal(30, 1);

            if (isChangedState) 
                return;
            
            if (angleToTarget is < 30 and > -30)
            {
                anim.SetInteger("IDInt", idInt);
                anim.SetBool("Attack", true);
            }
            else if (angleToTarget is > 150 or < -150)
            {
                anim.SetBool("Attack", true);
                anim.SetInteger("IDInt", 4);
                Debug.Log("back attack");
            }
        }

        public override void Transition()
        {
            if (target is null)
                ChangeState(State.Idle);
            
            if (distanceToTarget > moose.Data.TrackingDistance) 
                ChangeState(State.Patrol);

            if(isChangedState || distanceToTarget > moose.Data.AttackRange) 
                ChangeState(State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Attack", false);
            
            if (count == 1) 
                target.gameObject.GetComponent<Player>().TakeDamage(moose.CurrentStat.Attack);
        }
    }
}