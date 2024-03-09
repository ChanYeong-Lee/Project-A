using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class RoarState : BearState
    {
        public RoarState(Creature owner) : base(owner) { }

        public override void Enter()
        {
        }

        public override void Update() 
        {
        }

        public override void Exit() { }


        public override void Transition()
        {

        }
    }
}