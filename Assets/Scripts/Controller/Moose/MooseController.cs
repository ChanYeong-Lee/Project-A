using UnityEngine;
using MonsterController;
using State = Define.MooseState;

namespace MooseController
{
    public class MooseState : MonsterState
    {
        protected Moose moose => monster as Moose;
        protected float randTime;
        protected bool isChangedState;
        protected bool isUnderAttack;
        protected float attackCooldown;
        protected float vertical;
        protected float horizontal;
        protected int idInt;

        protected float distanceToTarget;
        protected float angleToTarget;
        
        public MooseState(Creature owner) : base(owner) { }

        public override void Update()
        {
            randTime -= Time.deltaTime;            
            attackCooldown -= Time.deltaTime;
            
            if (target is not null)
            {
                distanceToTarget = Vector3.Distance(target.transform.position, moose.transform.position);
                angleToTarget = Vector3.SignedAngle(moose.transform.forward,
                    target.transform.position - moose.transform.position, Vector3.up);
            }

            // TODO : 충돌 검사
            // if (Physics.Raycast(moose.body.position, Vector3.down, out RaycastHit hit))
            // {
            //     Vector3 normal = hit.normal;
            //     Vector3.Angle(moose.GetComponent<Transform>().position, normal);
            // }
            
            // 인스펙터 확인용 코드
            moose.time = randTime;
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
            {
                return;
            }
            
            if (angleToTarget  < angle && angleToTarget > -angle)
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), 0, Time.deltaTime));
            else if (angleToTarget > angle)
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), horizontal, Time.deltaTime));
            else if (angleToTarget < -angle) 
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -horizontal, Time.deltaTime));
        }
    }
}
