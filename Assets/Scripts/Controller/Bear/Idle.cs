using Unity.VisualScripting.FullSerializer;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class IdleState : BearState
    {
        public IdleState(Creature owner) : base(owner) { }

        private float waitTime = 5.0f;
        private float waitTimeDelta = 0.0f;
        private Vector3 dest = Vector3.zero;

        public override void Enter()
        {
            bear.state = State.Idle;
            velocity = 1.0f;
            ChangeDirectMode(DirectMode.Manual);

            dest = bear.transform.position + GRV;
            waitTimeDelta = waitTime;

            bear.Agent.SetDestination(dest);
        }
        public override void Exit()
        {
            bear.Agent.ResetPath();
        }

        public override void Update()
        {
            base.Update();

            if (bear.Agent.remainingDistance < 5.0f)
            {
                waitTimeDelta -= Time.deltaTime;
                bear.Agent.ResetPath();

                if (waitTimeDelta < 0.0f)
                {
                    waitTimeDelta = waitTime;
                    dest = bear.transform.position + GRV;
                    bear.Agent.SetDestination(dest);
                }
            }
        }

        public override void Transition()
        {
            if (target != null)
            {
                ChangeState(State.Trace);
            }

            ChangeState(State.Rush);
        }

        private Vector3 GRV => GenerateRandomVector();
        private Vector3 GenerateRandomVector()
        {
            float randomFloat = Random.Range(50.0f, 100.0f);
            Vector2 randomVec = Random.insideUnitCircle;
            
            randomVec.Normalize();
            randomVec *= randomFloat;

            return new Vector3(randomVec.x, 0.0f,randomVec.y);
        }
    }

}