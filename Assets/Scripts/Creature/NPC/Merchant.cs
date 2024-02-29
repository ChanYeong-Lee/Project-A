using System;
using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;
using Random = UnityEngine.Random;
using State = Define.MerchantState;
using MerchantController;

[DisallowMultipleComponent]
[RequireComponent(typeof(NavMeshAgent), typeof(Animator))]

public class Merchant : NPC
{
    [Space(2f)]
    [SerializeField] public State state;
    [SerializeField] private NavMeshAgent agent;
    protected NavMeshTriangulation triangulation;

    [Space(2f)]
    public Vector2 vel;
    public Vector2 smoothDeltaPos;
    [Space(2f)]
    [Range(0f, 3f)] public float waitDelay = 1f;
    
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
        anim = GetComponent<Animator>();
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
    private void Update()
    {
        SynchronizeAnimatiorAndAgent();
    }

    public void RoamingAround()
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

        //dx: 현재 위치에서 x축으로 1만큼 가기 위해서 실제로 이동할 거리
        float dx = Vector3.Dot(transform.right, worldDeltaPosition);
        //dy: 현재 위치에서 z축으로 1만큼 더 가기 위해서 실제로 이동할 거리.
        float dy = Vector3.Dot(transform.forward, worldDeltaPosition);

        //dx, dy만큼 가기 위해서의 이동 백터(방향과 거리를 포함)
        Vector2 deltaPosition = new Vector2(dx, dy);

        // Low-pass filter the deltaMove
        float smooth = Mathf.Min(1, Time.deltaTime / 0.1f);
        // filter를 거친 현재 현재에서 이동 백터만큼 보간 값
        smoothDeltaPos = Vector2.Lerp(smoothDeltaPos, deltaPosition, smooth);

        //프레임간 이동량
         vel = smoothDeltaPos / Time.deltaTime;
       
        if (agent.remainingDistance <= agent.stoppingDistance)
        {
            vel = Vector2.Lerp(Vector2.zero, vel, agent.remainingDistance);
        } 

        bool shouldMove = vel.magnitude > 0.5f && agent.remainingDistance > agent.stoppingDistance;

        anim.SetBool("move", shouldMove);
        anim.SetFloat("velx", vel.x);
        anim.SetFloat("vely", vel.y);

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

}
