using System;
using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;
using static UnityEngine.Rendering.DebugUI;

public class Merchant : NPC
{
    [SerializeField] public State state;
    [SerializeField] private NavMeshAgent agent;
    protected NavMeshTriangulation triangulation;

    [Range(0f, 3f)]private float waitDelay = 1f;

    public Vector3 nexPos;
    public Vector2 vel;
    public Vector2 smoothDeltaPos;

    public enum State
    {
        Idle,
        Wander,
        RunAway,
        Interact,
    }
    private void OnAnimatorMove()
    {
        Vector3 rootPosition = anim.rootPosition;
        rootPosition.y = agent.nextPosition.y;
        transform.position = rootPosition;
        agent.nextPosition = rootPosition;
    }

    public override void Init()
    {
        base.Init();
        agent = GetComponent<NavMeshAgent>();
        triangulation = NavMesh.CalculateTriangulation();
        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Wander, new WanderState(this));
        stateMachine.AddState(State.RunAway, new RnuAwayState(this));
        stateMachine.AddState(State.Interact, new InteractState(this));
        stateMachine.InitState(State.Idle);

        anim.applyRootMotion = true;
        agent.updatePosition = false;
        agent.updateRotation = true;

    }

    protected void RoamingAround()
    {
        _=StartCoroutine(MoveToRandomPos());
    }

    public void SetRandomPos()
    {
        int index = UnityEngine.Random.Range(1, triangulation.vertices.Length - 1);
        agent.SetDestination(Vector3.Lerp(triangulation.vertices[index],
                            triangulation.vertices[index + (UnityEngine.Random.value > 0.5f ? -1 : 1)], UnityEngine.Random.value));
    }

    private IEnumerator MoveToRandomPos()
    {
        agent.enabled = true;
        agent.isStopped = false;
        WaitForSeconds wait = new WaitForSeconds(waitDelay);
       
        while (true)
        {
          
            int index = UnityEngine.Random.Range(1, triangulation.vertices.Length - 1);
            agent.SetDestination(Vector3.Lerp(triangulation.vertices[index], 
                triangulation.vertices[index + (UnityEngine.Random.value > 0.5f ? -1 : 1)], UnityEngine.Random.value));
            print(triangulation.vertices.Length);
            yield return null;
            yield return new WaitUntil(()=> agent.remainingDistance <= agent.stoppingDistance);
            yield return wait;
        }
    }

    protected void StopMoving()
    {
        agent.isStopped = true;
        StopAllCoroutines();
    }

    private void SynchronizeAnimatiorAndAgent()
    {
        Vector3 worldDeltaPosition = agent.nextPosition - transform.position;
        worldDeltaPosition.y = 0;

        //Map worldDeltaPos to local space
        // 이동하는 방향으로 회전하고, 그 전까지는 anglur만 돌리는 로직
        float dx = Vector3.Dot(transform.right, worldDeltaPosition);
        float dy = Vector3.Dot(transform.forward, worldDeltaPosition);
        Vector2 deltaPosition = new Vector2(dx, dy);

        // Low-pass filter the deltaMove
        float smooth = Mathf.Min(1, Time.deltaTime * 10.0f);
        smoothDeltaPos = Vector2.Lerp(smoothDeltaPos, deltaPosition, smooth);

        vel = smoothDeltaPos / Time.deltaTime;

        if (agent.remainingDistance <= agent.stoppingDistance)
        {
            vel = Vector2.Lerp(Vector2.zero, vel, agent.remainingDistance / agent.stoppingDistance);
        } // 회전하는 로직

        bool shouldMove = vel.magnitude > 0.5f && agent.remainingDistance > agent.stoppingDistance;

        anim.SetBool("move", shouldMove);
        anim.SetFloat("velx", vel.x);
        anim.SetFloat("vely", vel.y);

        //anim.SetFloat("Wander", vel.magnitude);

        //float deltaMagnitude = worldDeltaPosition.magnitude;
        //if (deltaMagnitude > agent.radius / 2f)
        //{
        //    transform.position = Vector3.Lerp(anim.rootPosition, agent.nextPosition, smooth);
        //}
    }

    private void Update()
    {
        SynchronizeAnimatiorAndAgent();
    }

    protected void SwitchAnimation(State state, float value)
    {
        anim.SetFloat(state.ToString(), value);
    }
    protected void SwitchAnimation(State state, bool value)
    {
        anim.SetBool(state.ToString(), value);
    }
    protected void SwitchAnimation(State state)
    {
        anim.SetTrigger(state.ToString());
    }

    #region State

    private class MerchantState : NPCState
    {
        public Merchant Owner => base.owner as Merchant;
        protected float CurSpeed
        {
            get { return Owner.CurSpeed; }
            set { Owner.CurSpeed = value; }
        }

        public MerchantState(Creature owner) : base(owner) { }
    }

    private class IdleState : MerchantState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Debug.Log("Idle Enter");
            ChangeState(State.Wander);
      

        }
        public override void Transition()
        {
           
        }
        public override void Exit()
        {
           
        }
    }

    private class WanderState : MerchantState
    { 
        public WanderState(Creature owner) : base(owner) { }
        public override void Enter()
        {
            
        }
        public override void Update()
        {
            Debug.Log("Wander Update");
            
        }
        public override void Transition()
        {

        }

        private void Move()
        {

           
        }

    }

    private class RnuAwayState : MerchantState
    {
        public RnuAwayState(Creature owner) : base(owner) { }

        public override void Transition()
        {
            ChangeState(State.RunAway);
        }
        public override void Update()
        {

        }
    }

    private class InteractState : MerchantState
    {
        public InteractState(Creature owner) : base(owner) { }

        public override void Update()
        {
            CurSpeed = 0;
        }

        public override void Transition()
        {
            ChangeState(State.Interact);

        }
    }
    #endregion

}
