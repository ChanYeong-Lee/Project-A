using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class RoarState : BearState
    {
        private float roarTime = 0.0f;
        public RoarState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            bear.state = State.Roar;

            roarTime = 3.0f;
            ChangeDirectMode(DirectMode.Manual);
            
            targeting = false;
            animated = false;

            randomValue = Random.Range(0, 2);
            bear.Agent.SetDestination(bear.MoveTarget.position);
        }

        public override void Update() 
        {
            if (targeting == false)
            {
                Vector3 lookAt = (bear.Agent.steeringTarget - bear.transform.position).normalized;

                if (Mathf.Abs(Vector3.Dot(lookAt, bear.transform.forward)) < 0.9f)
                {
                    bear.transform.rotation = Quaternion.Lerp(bear.transform.rotation, Quaternion.LookRotation(lookAt, bear.transform.up), 5.0f * Time.deltaTime);

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
                if (animated == false)
                {
                    switch (randomValue)
                    {
                        case 0:
                            anim.CrossFade("Roar", 0.2f);
                            break;
                        case 1:
                            anim.CrossFade("StandRoar", 0.2f);
                            break;
                    }
                    animated = true;
                }

                velocity = 0.0f;
                angularVelocity = 0.0f;
            }

            roarTime -= Time.deltaTime;
        }

        public override void Exit()
        {
            bear.roarCooldownDelta = bear.roarCooldown;
        }

        public override void Transition()
        {
            if (roarTime < 0.0f && anim.GetCurrentAnimatorStateInfo(0).IsName("Locomotion"))
            {
                ChangeState(State.Think);
            }
        }
    }
}