using MonsterController;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class BearState : MonsterState
    {

        protected Bear bear => monster as Bear;

        protected float randTime;

        protected bool isChangedState;

        // protected bool isUnderAttack;
        protected float attackCooldown;
        protected float vertical;
        protected float horizontal;
        protected int idInt;

        protected float distanceToTarget;
        protected float angleToTarget;
        protected float angleCoefficient = 0.0f;

        protected float moreSpeed = 1.0f;
            
        public BearState(Creature owner) : base(owner)
        {
        }

        public override void Update()
        {
            randTime -= Time.deltaTime;
            attackCooldown -= Time.deltaTime;
            bear.angleToTarget = angleToTarget;
            
            if (target != null)
            {
                distanceToTarget = Vector3.Distance(target.transform.position, bear.transform.position);
                angleToTarget = Vector3.SignedAngle(bear.transform.forward,
                    target.transform.position - bear.transform.position, Vector3.up);
            }
            else
            {
                distanceToTarget = bear.Data.TrackingDistance * 2;
            }
        }

        public override void FixedUpdate()
        {
            if (bear.state == State.Idle)
                return;
            

            if (Physics.Raycast(bear.Body.transform.position + Vector3.up, Vector3.down, out var hit, Mathf.Infinity))
            {
                Vector3 normal = hit.normal;
                
                var angle = Vector3.SignedAngle(bear.Body.transform.forward, normal, bear.Body.transform.right) + 90;
                bear.transform.position += bear.rootMotion;
                // bear.transform.rotation *= Quaternion.Euler(angle - bear.transform.rotation.x, bear.rootRotation.eulerAngles.y, 0.0f);
            
                bear.rootMotion = Vector3.zero;
                bear.rootRotation = Quaternion.identity;

                bear.slopeAngle = angle;
                float deltaAngle = angle - bear.transform.rotation.eulerAngles.x;
                Debug.
                bear.transform.rotation *= Quaternion.Euler(0.0f, anim.GetFloat("Horizontal") * 90.0f * moreSpeed * Time.fixedDeltaTime, 0);
            }
            else
            {
                bear.rootMotion = Vector3.zero;
                bear.rootRotation = Quaternion.identity;
            }

            // isUnderAttack = anim.GetBool("Damaged");
        }

        // ���� �� ����
        // ���� ��ġ �� �Ϻ� ���� ������ �Լ�(�ּ� �ð�, �ִ� �ð�, ���� �ӽ� �ٲ� Ȯ��)
        protected void RandVariable(float minTime = 1f, float maxTime = 10f, float rateToChange = 0.5f)
        {
            randTime = Random.Range(minTime, maxTime);
            isChangedState = Random.value < rateToChange;
            vertical = Random.Range(-1f, 5f);
            horizontal = Random.Range(-2f, 2f);
            idInt = Random.Range(-1, 11);
        }

        protected void FixedHorizontal(float angle = 5, float horizontal = 2)
        {
            if (distanceToTarget < 2)
                return;

            angleCoefficient = (Mathf.Abs(angleToTarget) - angle) / 180.0f;

            if (angleToTarget <= angle && angleToTarget >= -angle)
                anim.SetFloat("Horizontal", 0.0f);
            else if (angleToTarget > angle)
                anim.SetFloat("Horizontal", Mathf.Lerp(0, horizontal, angleCoefficient));
            else if (angleToTarget < -angle)
                anim.SetFloat("Horizontal", Mathf.Lerp(0,  -horizontal, angleCoefficient));
        }

        protected void MoreSpeed()
        {
            if (2.9f < anim.GetFloat("Vertical"))
            {
                moreSpeed += Time.fixedDeltaTime / 10.0f;
                moreSpeed = Mathf.Clamp(moreSpeed, 1.0f, 1.5f);
            }
            else
            {
                moreSpeed = Mathf.Lerp(moreSpeed, 1.0f, Time.fixedDeltaTime);
            }
            anim.SetFloat("MoreSpeed", moreSpeed);
        }
    }
}