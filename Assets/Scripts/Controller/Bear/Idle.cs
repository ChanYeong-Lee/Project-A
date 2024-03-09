using Unity.VisualScripting.FullSerializer;
using UnityEngine;
using State = Define.BearState;

namespace BearController
{
    public class IdleState : BearState
    {
        public IdleState(Creature owner) : base(owner) { }

        private float waitTime = 5.0f;

        private Vector3 origin = Vector3.zero;
        private Vector3 dest = Vector3.zero;
        private float radius = 150.0f;

        public override void Enter()
        {
            origin = bear.transform.position;

            bear.state = State.Idle;
            
            ChangeDirectMode(DirectMode.Auto);
            velocity = Random.Range(1.0f, 2.0f);

            dest = bear.transform.position + GRV;
            waitTime = Random.Range(2.0f, 5.0f);

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
                waitTime -= Time.deltaTime;
                bear.Agent.ResetPath();

                if (waitTime < 0.0f)
                {
                    do
                    {
                        dest = bear.transform.position + GRV;
                    } while (radius < Vector3.Distance(origin, dest));

                    bear.Agent.SetDestination(dest);
                    waitTime = Random.Range(2.0f, 5.0f);
                }
            }
        }

        public override void Transition()
        {
            if (target != null)
            {
                ChangeState(State.Think);
            }
        }

        private Vector3 GRV => GenerateRandomVector();
        private Vector3 GenerateRandomVector()
        {
            float randomFloat = Random.Range(30.0f, 50.0f);
            Vector2 randomVec = Random.insideUnitCircle;
            
            randomVec.Normalize();
            randomVec *= randomFloat;

            return new Vector3(randomVec.x, 0.0f,randomVec.y);
        }
    }

}