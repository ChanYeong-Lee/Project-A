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
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            
            Collider[] colliders = new Collider[2];
            int count = Physics.OverlapSphereNonAlloc(moose.Eyes.position, 0.5f, colliders, moose.Detection);
            
            if (count == 0)
            {
                anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), horizontal, Time.deltaTime));
            }
            else if (count == 1)
            {
                var collisionAngle = Vector3.SignedAngle(moose.transform.forward,
                    colliders[0].transform.position - moose.transform.position, Vector3.up);

                Debug.Log("patrol turn");
                switch (collisionAngle)
                {
                    case < 90 and > 45:
                        anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.fixedDeltaTime));
                        anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), 0, Time.fixedDeltaTime * 10));
                        break;
                    case < 45 and > 0:
                        anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.fixedDeltaTime));
                        anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), -1, Time.fixedDeltaTime * 10));
                        break;
                    case > -45 and < 0:
                        anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), 2, Time.fixedDeltaTime));
                        anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), -1, Time.fixedDeltaTime * 10));
                        break;
                    case > -90 and < -45:
                        anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), 2, Time.fixedDeltaTime));
                        anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), 0, Time.fixedDeltaTime * 10));
                        break;
                }
            }
            else
            {
                var collisionAngle = Vector3.SignedAngle(moose.transform.forward,
                    colliders[0].transform.position - moose.transform.position, Vector3.up);
                
                anim.SetFloat("Vertical", -1);
                anim.SetFloat("Horizontal", collisionAngle > 0 ? 2 : -2);
            }


            if (randTime < 0) 
                RandVariable(1f,2f, 0.3f);
        }

        public override void Transition()
        {
            if (isChangedState) 
                ChangeState(State.Idle);
            
            // if (isUnderAttack) 
            //     ChangeState(State.TakeAttack);
            
            if (moose.Data.IsAggressive && distanceToTarget < moose.Data.TrackingDistance) 
                ChangeState(State.Trace);
        }
        
        private void Turn()
        {
            Debug.Log("turn");
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), 0, Time.deltaTime));
            anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.deltaTime));
        }
    }
}