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
        
        public BearState(Creature owner) : base(owner) { }

        public override void Update()
        {
            randTime -= Time.deltaTime;            
            attackCooldown -= Time.deltaTime;
            
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
            
            if (Physics.Raycast(bear.Body.transform.position, Vector3.down, out var hit))
            {
                Vector3 normal = hit.normal;
                var angle = Vector3.SignedAngle(bear.Body.transform.forward, normal, bear.Body.transform.right) + 90;

                bear.angle = angle;
                bear.transform.localRotation = Quaternion.Slerp(bear.transform.localRotation,
                    Quaternion.Euler(angle, anim.GetFloat("Horizontal") * 100 + bear.transform.rotation.eulerAngles.y, 0), Time.fixedDeltaTime);
            }

            // isUnderAttack = anim.GetBool("Damaged");
        }

        // 랜덤 값 생성
        // 랜덤 수치 값 일부 조정 가능한 함수(최소 시간, 최대 시간, 상태 머신 바뀔 확률)
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
            
            if (angleToTarget  < angle && angleToTarget > -angle)
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), 0, Time.fixedDeltaTime));
            else if (angleToTarget > angle)
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), horizontal, Time.fixedDeltaTime));
            else if (angleToTarget < -angle) 
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -horizontal, Time.fixedDeltaTime));
        }    }
}