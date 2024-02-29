using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.MerchantState;

namespace MerchantController { 
public class WanderState : MerchantState
{
    public WanderState(Creature owner) : base(owner) { }
    public override void Enter()
    {

    }
    public override void Update()
    {
        Owner.RoamingAround();


    }
    public override void Transition()
    {

    }

}
}