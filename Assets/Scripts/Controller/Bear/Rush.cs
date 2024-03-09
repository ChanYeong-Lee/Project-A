using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class RushState : BearState
    {
        private float rushTime = 0.0f;
        
        public RushState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            bear.state = State.Rush;

            rushTime = 3.0f; 
            ChangeDirectMode(DirectMode.Manual);
            targeting = false;

            Vector3 dir = (bear.MoveTarget.position - bear.transform.position).normalized;
            bear.Agent.SetDestination(bear.MoveTarget.position + dir * 20.0f);
        }

        public override void Update()
        {
            base.Update();
            rushTime -= Time.deltaTime;

            if (targeting == false)
            {
                Debug.Log("Rush Targetting");


                Vector3 dir = (target.position - bear.transform.position).normalized;
                bear.Agent.SetDestination(target.position + dir * 20.0f);
                Vector3 lookAt = (target.position + dir * 20.0f - bear.transform.position).normalized;

                if (Mathf.Abs(Vector3.Dot(lookAt, bear.transform.forward)) < 0.95f)
                {
                    bear.transform.rotation = Quaternion.Lerp(bear.transform.rotation, Quaternion.LookRotation(lookAt, bear.transform.up), Time.deltaTime);

                    velocity = 0.0f;
                    angularVelocity = horizontal;
                }
                else
                {
                    targeting = true;
                }
            }
            else
            {
                Debug.Log("Rushing");
                Vector3 lookAt = (bear.Agent.steeringTarget - bear.transform.position).normalized;
                if (lookAt != Vector3.zero)
                {
                    bear.transform.rotation = Quaternion.LookRotation(lookAt, bear.transform.up);
                }

                velocity = 3.0f;
                angularVelocity = 0.0f;
            }
        }

        public override void Exit()
        {
            bear.lastState = State.Rush;
        }

        public override void Transition()
        {
            AttackTransition();

            if (rushTime < 0.0f || bear.Agent.remainingDistance < 5.0f)
            {
                ChangeState(State.Think);
            }
        }
    }
}