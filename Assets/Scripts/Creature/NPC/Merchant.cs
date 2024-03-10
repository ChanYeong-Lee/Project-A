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
    [SerializeField] public NavMeshAgent agent;
    [HideInInspector] protected NavMeshTriangulation triangulation;
    [SerializeField] private LookAt lookat;

    [Header("이동 관련 자료형")]
    [Space(2f)]
    public Vector2 vel;
    public Vector2 smoothDeltaPos;
    [Space(2f)]
    [Range(0f, 3f)] public float waitDelay = 1f;

    [Header("상호작용 관련 자료형")]
    [HideInInspector] public Vector3 interactionBounds = new Vector3(10, 2, 10);
    [SerializeField] private LayerMask interactable;
    public LayerMask Interactable => interactable;
    [HideInInspector] public Collider interactibleCollider;
    public Collider[] nearbyColliders;


    [Header("RunAwawy 상태 관련 자료")]
    public List<Transform> safezones;

    [Header("퀘스트 관련 자료형")]
    public Collider col;
 
    private void OnAnimatorMove()
    {
        Vector3 rootPosition = anim.rootPosition;
        rootPosition.y = agent.nextPosition.y;
        transform.position = rootPosition;
        agent.nextPosition = rootPosition;
    }
    private void Update()
    {
        SynchronizeAnimatiorAndAgent();
        Overlap();
    }

    private void OnDrawGizmos()
    {
        Gizmos.matrix = transform.localToWorldMatrix * Matrix4x4.Scale(interactionBounds);
        Gizmos.color = Color.red;
        Gizmos.DrawWireCube(new Vector3(0, 0.5f, 0), Vector3.one);
    }

  

    public override void Init()
    {
        base.Init();
        agent = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
        col = GetComponentInChildren<CapsuleCollider>();
        interactibleCollider = GetComponentInChildren<CapsuleCollider>();
        triangulation = NavMesh.CalculateTriangulation();

        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Wander, new WanderState(this));
        stateMachine.AddState(State.RunAway, new RnuAwayState(this));
        stateMachine.AddState(State.Interact, new InteractState(this));
        stateMachine.InitState(State.Idle);

        anim.applyRootMotion = true;
        agent.updatePosition = false;
        agent.updateRotation = true;
        agent.enabled = true;
        //CollisionOn();
    }
   

    public void BeginWandering()
    {
        EnableAgentMovement();
        _ = StartCoroutine(MoveToRandomPos());
    }

    public void SetRandomWaypoint()
    {
        int index = Random.Range(1, triangulation.vertices.Length - 1);
        agent.SetDestination(Vector3.Lerp(triangulation.vertices[index],
                            triangulation.vertices[index + (Random.value > 0.5f ? -1 : 1)], Random.value));
    }

    public void Overlap()
    {
        nearbyColliders = Physics.OverlapBox(transform.position + transform.up,
                          interactionBounds * 0.5f, transform.rotation, interactable);
        
    }

    private IEnumerator MoveToRandomPos()
    {
        
        agent.isStopped = false;

        WaitForSeconds wait = new WaitForSeconds(waitDelay);

        while (true)
        {
            int index = Random.Range(1, triangulation.vertices.Length - 1);
            agent.SetDestination(Vector3.Lerp(triangulation.vertices[index],
                triangulation.vertices[index + (Random.value > 0.5f ? -1 : 1)], Random.value));

            yield return null;
            yield return new WaitUntil(() => agent.remainingDistance <= agent.stoppingDistance);
            yield return wait;
        }
    }

    public void DisableAgentMovement()
    {
        agent.ResetPath();
        agent.isStopped = true;
        StopAllCoroutines();
    }
    public void EnableAgentMovement()
    {
        if (false == agent.enabled) { agent.enabled = true; }
        agent.isStopped = false;
    }

    //상태머신의 경로를 정할때 사용
    public void SetDestination(Vector3 target)
    {
        EnableAgentMovement();
        agent.SetDestination(target);
    }

    private void SynchronizeAnimatiorAndAgent() 
    {
        if (agent.enabled == true)
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

            lookat.lookAtTargetPosition = agent.steeringTarget + transform.forward;
        }
       

    }

    public void CollisionOn()
    {
        if (!interactibleCollider.enabled) {interactibleCollider.enabled = true; }
    }
    public void CollisionOff()
    {
        if (interactibleCollider.enabled) { interactibleCollider.enabled = false; }
    }

    #region ChangeAnimation
    public void SwitchAnimation(State state, float value)
    {
        anim.SetFloat(state.ToString(), value);
    }
    public void SwitchAnimation(State state, bool value)
    {
        anim.SetBool(state.ToString(), value);
    }
    public void SwitchAnimation(State state)
    {
        anim.SetTrigger(state.ToString());
    }
    #endregion
}
