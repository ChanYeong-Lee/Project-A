using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class RnuAwayState : MerchantState
    {
        Transform neariestZone = null;
        float literalDelay = 2.5f;
        float waitDelay = 2.5f;
        public RnuAwayState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Debug.Log("RunAwayState Enter");
            Owner.state = State.RunAway;
            if (neariestZone == null)
            {
                FindNeariestZone();
            }

        }
        public override void Update()
        {
            waitDelay -= Time.deltaTime;

        }
        public override void Transition()
        {

            if (waitDelay <= 0)
            {
                waitDelay = literalDelay;
                CheckEnemy();
            }
        }
        public void FindNeariestZone()
        {
            float zoneDistance = Mathf.Infinity;
            float targetDistance = Vector3.Distance(Owner.transform.position, Owner.target.transform.position);
            for (int i = 0; i < Owner.safezones.Count; i++)
            {
                float neariestDistance = Vector3.Distance(Owner.transform.position, Owner.safezones[i].position);
                //TODO:SafeZone에 Collider 추가하여 몬스터가 들어올 수 없도록 수정 예정
                //targetDistance가 가장 가까운 세이프존보다 가까울 경우, 세이프존으로 이동하지 않도록 수정
                //targetDistance > neariestDistance 추가하면 오류 발생
                if (zoneDistance > neariestDistance)
                {
                    zoneDistance = neariestDistance;
                    neariestZone = Owner.safezones[i];

                }
            }
            if (neariestZone != null)
            {
                Owner.Anim.SetTrigger("FaceEnemy");
                Owner.SetDestination(neariestZone.position);
            }

        }

        // 오버랩안에 적이 있는 경우, 계속해서 세이프존으로 이동
        //없을 경우 Idle로 전환
        public void CheckEnemy()
        {//TODO: if 문 수정 예정. 
            if (Owner.cols.Count() == 0)
            {
                neariestZone = null;
                ChangeState(State.Idle);
                return;
            }
            foreach (Collider col in Owner.cols)
            {
                if (col.gameObject.layer == LayerMask.NameToLayer("Enemy"))
                {

                }
                else
                {
                    ChangeState(State.Idle);
                }
            }
        }

    }
}