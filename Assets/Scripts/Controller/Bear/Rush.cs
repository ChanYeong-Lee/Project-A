using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class RushState : BearState
    {
        private float rushTime;
        
        public RushState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Debug.Log("Rush");
            rushTime = 10f;
            bear.state = State.Rush;
        }

        public override void Update()
        {
            base.Update();

            rushTime -= Time.deltaTime;
            
            // 거리에 따른 속도값 조절 필요
            if (distanceToTarget > bear.Data.AttackRange)
                vertical = 3.0f;
            else if (distanceToTarget > bear.Data.AttackRange / 2)
                vertical = distanceToTarget / 2;
            else
                vertical = 0;
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            if (false == canMove)
                return;
            
            FixedHorizontal(0);
            MoreSpeed();
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.fixedDeltaTime));
        }

        public override void Transition()
        {
            base.Transition();
            
            if (rushTime < 0) 
                ChangeState(State.Trace);

            if (distanceToTarget < bear.Data.AttackRange && attackCooldown < 0) 
                ChangeState(State.Attack);
        }

        public override void Exit()
        {
            rushCooldown = 10f;
            idInt = Random.Range(1, 3);
            base.Exit();
        }
    }
}