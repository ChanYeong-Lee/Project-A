using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class RnuAwayState : MerchantState
    {
        float literalDelay = 2.5f;
        float waitDelay = 2.5f;
        public RnuAwayState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Debug.Log("RunAwayState Enter");
            Owner.state = State.RunAway;
            FindNeariestZone();
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
            Transform neariestZone = null;
            float zoneDistance = Mathf.Infinity;

            for (int i = 0; i < Owner.safezones.Count; i++)
            {
                float neariestDistance = Vector3.Distance(Owner.transform.position, Owner.safezones[i].position);
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
            else
            {
                FindNeariestZone();
            }
        }

        // 오버랩안에 적이 있는 경우, 계속해서 세이프존으로 이동
        //없을 경우 Idle로 전환
        public void CheckEnemy()
        {
            if (Owner.cols.Count() == 0) { ChangeState(State.Idle); return; }
            foreach (Collider col in Owner.cols)
            {
                Debug.Log(col.name);
                if (col.gameObject.layer == LayerMask.NameToLayer("Enemy"))
                {
                 
                }
                else
                {
                    Debug.Log("Idle로 전환");
                    ChangeState(State.Idle);
                }
            }
        }

    }
}