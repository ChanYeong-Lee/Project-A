using UnityEngine;
using State = Define.MooseState;

namespace MooseController
{
    public class PatrolState : MooseState
    {
        public PatrolState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            // 인스펙터 확인용 코드
            moose.state = State.Patrol;
            
            RandVariable(1f, 5f, 0);

            anim.SetBool("Stand", false);
        }

        public override void Update()
        {
            base.Update();
            
            Collider[] colliders = new Collider[1];
            int count = Physics.OverlapSphereNonAlloc(moose.Eyes.position, 0.3f, colliders, moose.Detection);

            if (count != 0)
                Turn();
            else
                Move();

            if (randTime < 0) 
                RandVariable(1f,2f, 0.3f);
        }

        public override void Transition()
        {
            base.Transition();
            
            // Idle
            if (isChangedState) 
                ChangeState(State.Idle);
        }

        private void Move()
        {
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
            anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), horizontal, Time.deltaTime));
        }
        
        private void Turn()
        {
            Debug.Log("turn");
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), 0, Time.deltaTime));
            anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.deltaTime));
        }
    }
}