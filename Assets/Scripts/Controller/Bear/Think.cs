using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Rendering.Universal;
using State = Define.BearState;

namespace BearController
{
    public class ThinkState : BearState
    {
        public ThinkState(Creature owner) : base(owner) { }

        private bool stateAgain;
        private State newState;
        public override void Enter()
        {
            stateAgain = true;

            while (stateAgain)
            {
                randomValue = Random.Range(0, 3);
                switch (randomValue)
                {
                    case 0:
                        newState = State.Prowl;
                        break;
                    case 1:
                        newState = State.Trace;
                        break;
                    case 2:
                        newState = State.Rush;
                        break;
                }
                stateAgain = bear.lastState == newState;
            }

            Debug.Log($"Think, new State = {newState}");
        }

        public override void Transition()
        {
            if (bear.roarCooldownDelta < 0.0f)
            {
                ChangeState(State.Roar);
            }
            else
            {
                ChangeState(newState);
            }
        }
    }
}