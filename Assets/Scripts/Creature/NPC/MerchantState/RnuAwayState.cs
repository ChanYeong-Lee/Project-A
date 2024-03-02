using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController
{
    public class RnuAwayState : MerchantState
    {
        

        public RnuAwayState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Debug.Log("RunAwayState Enter");
            Owner.state = State.RunAway;
            FindNeariestZone();
        }
        public override void Update()
        {


        }
        public override void Transition()
        {

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
                
                Owner.KeepMoving();
                Owner.agent.SetDestination(neariestZone.position);

            }
            else
            {
                FindNeariestZone();
            }
        }

    }
}