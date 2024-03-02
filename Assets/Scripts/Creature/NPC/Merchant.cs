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
using System.Linq;
using static UnityEngine.UI.GridLayoutGroup;
using JetBrains.Annotations;
using System.Linq.Expressions;
using static UnityEditor.PlayerSettings;

[DisallowMultipleComponent]
[RequireComponent(typeof(NavMeshAgent), typeof(Animator))]

public class Merchant : NPC
{
    [Space(2f)]
    [SerializeField] public State state;
    public string currentState;
    [SerializeField] public NavMeshAgent agent;
    protected NavMeshTriangulation triangulation;

    [Header("�̵� ���� �ڷ���")]
    [Space(2f)]
    public Vector2 vel;
    public Vector2 smoothDeltaPos;
    [Space(2f)]
    [Range(0f, 3f)] public float waitDelay = 1f;

    [Header("��ȣ�ۿ� ���� �ڷ���")]
    public Vector3 overlapBoxSize = new Vector3(2, 2, 2);
    [SerializeField] private LayerMask interactable;
    public LayerMask Interactable => interactable;

    [Header("RunAwawy ���� ���� �ڷ�")]
    public List<Transform> safezones;
 

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

    }

    private void OnDrawGizmos()
    {
        Gizmos.matrix = transform.localToWorldMatrix;
        Gizmos.color = Color.red;
        Gizmos.DrawWireCube(Vector3.up, overlapBoxSize);
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
        agent.enabled = true;

    }
   

    public void RoamingAround()
    {
        _ = StartCoroutine(MoveToRandomPos());
    }

    public void SetRandomPos()
    {
        int index = Random.Range(1, triangulation.vertices.Length - 1);
        agent.SetDestination(Vector3.Lerp(triangulation.vertices[index],
                            triangulation.vertices[index + (Random.value > 0.5f ? -1 : 1)], Random.value));
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

    public void StopMoving()
    {
        agent.isStopped = true;
        agent.enabled = false;
        StopAllCoroutines();
    }
    public void KeepMoving()
    {
        agent.isStopped = false;
        if (false == agent.enabled) { agent.enabled = true; }
    }

    private void SynchronizeAnimatiorAndAgent() 
    {
        Vector3 worldDeltaPosition = agent.nextPosition - transform.position;
        worldDeltaPosition.y = 0;

        //Map worldDeltaPos to local space

        //dx: ���� ��ġ���� x������ 1��ŭ ���� ���ؼ� ������ �̵��� �Ÿ�
        float dx = Vector3.Dot(transform.right, worldDeltaPosition);
        //dy: ���� ��ġ���� z������ 1��ŭ �� ���� ���ؼ� ������ �̵��� �Ÿ�.
        float dy = Vector3.Dot(transform.forward, worldDeltaPosition);

        //dx, dy��ŭ ���� ���ؼ��� �̵� ����(����� �Ÿ��� ����)
        Vector2 deltaPosition = new Vector2(dx, dy);

        // Low-pass filter the deltaMove
        float smooth = Mathf.Min(1, Time.deltaTime / 0.1f);
        // filter�� ��ģ ���� ���翡�� �̵� ���͸�ŭ ���� ��
        smoothDeltaPos = Vector2.Lerp(smoothDeltaPos, deltaPosition, smooth);

        //�����Ӱ� �̵���
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

    #region ChangeAnimation
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
    #endregion
}
