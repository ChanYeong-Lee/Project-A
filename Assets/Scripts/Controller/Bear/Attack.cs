using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class AttackState : BearState
    {
        public AttackState(Creature owner) : base(owner) { }

        private float attackTime = 0.0f;
        private int count = 0;

        public override void Enter()
        {
            bear.state = State.Attack;
            ChangeDirectMode(DirectMode.Manual);

            attackTime = 1.0f;
            bear.Agent.SetDestination(bear.MoveTarget.position);

            targeting = false;
            animated = false;

            randomValue = Random.Range(0, 3);
        }

        public override void Update()
        {
            base.Update();

            if (targeting == false)
            {
                Vector3 lookAt = (bear.Agent.steeringTarget - bear.transform.position).normalized;

                if (Mathf.Abs(Vector3.Dot(lookAt, bear.transform.forward)) < 0.9f)
                {
                    bear.transform.rotation = Quaternion.Lerp(bear.transform.rotation, Quaternion.LookRotation(lookAt, bear.transform.up), 10.0f * Time.deltaTime);

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
                            anim.CrossFade("Bite Left", 0.2f);
                            break;
                        case 1:
                            anim.CrossFade("Paw Left", 0.2f);
                            break;
                        case 2:
                            anim.CrossFade("Paws", 0.2f);
                            break;
                    }
                    animated = true;
                }

                Collider[] colliders = new Collider[1];
                count = Physics.OverlapBoxNonAlloc(bear.Eyes.transform.position, new Vector3(bear.Data.AttackRange, 1, 1), colliders,
                    Quaternion.identity, LayerMask.NameToLayer("Player"));
                velocity = 0.0f;
                angularVelocity = 0.0f;
            }

            attackTime -= Time.deltaTime;
        }

        public override void Exit()
        {
            bear.attackCooldownDelta = bear.attackCooldown;

            if (count == 1)
                target.gameObject.GetComponent<Player>().TakeDamage(bear.CurrentStat.Attack);
        }

        public override void Transition()
        {
            if (attackTime < 0.0f && anim.GetCurrentAnimatorStateInfo(0).IsName("Locomotion"))
            {
                ChangeState(State.Think);
            }
        }

    }
}