using BearController;
using System;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.Serialization;
using State = Define.BearState;



[Serializable]
public class CoolDown
{
    public State state;
    public float cooldown;
    public float cooldownDelta;
}


public class Bear : Monster
{
    [SerializeField] private Transform eyes;
    [SerializeField] private Transform body;
    [SerializeField] private LayerMask groundLayer;

    [SerializeField] private AnimationCurve upwardCurve;
    [SerializeField] private AnimationCurve downwardCurve;
    [SerializeField] private float faceCheck = 0.0f;

    [SerializeField] private List<CoolDown> cools;

    private Transform moveTarget;

    private NavMeshAgent agent;

    private int receivedDamage;
    
    // 인스펙터 확인용
    public State state;
    public float distance;
    public float slopeAngle;
    public float angleToTarget;
    public float traceAngle;

    public NavMeshAgent Agent => agent;
    public Transform Eyes => eyes;
    public Transform Body => body;
    public AnimationCurve UpwardCurve => upwardCurve;
    public AnimationCurve DownwardCurve => downwardCurve;
    public LayerMask GroundLayer => groundLayer;
    public int ReceivedDamage => receivedDamage;
    public float FaceCheck => faceCheck;
    public Transform MoveTarget => moveTarget;

    private void OnValidate()
    {
        if (agent == null)
        {
            agent = GetComponent<NavMeshAgent>();   
        }
    }

    public override void Init()
    {
        base.Init();

        agent = GetComponent<NavMeshAgent>();
        moveTarget = new GameObject("MoveTarget").transform;

        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Trace, new TraceState(this));
        stateMachine.AddState(State.Rush, new RushState(this));
        
        stateMachine.InitState(State.Idle);
    }

    public override void TakeDamage(ArrowData arrowData)
    {
        if (currentStat.HealthPoint <= 0)
            return;

        // 데미지 공식
        receivedDamage = arrowData.ArrowTrueDamage + (arrowData.ArrowDamage - currentStat.Defence > 0
            ? arrowData.ArrowDamage - currentStat.Defence
            : 0);

        if (state != State.Dead)
        {
            target = Managers.Game.Player.transform;
            stateMachine.ChangeState(State.TakeAttack);
        }
    }

    private void OnDrawGizmos()
    {
        if (agent.hasPath)
        {
            for (int i = 0; i < agent.path.corners.Length - 1; i++)
            {
                Debug.DrawLine(agent.path.corners[i], agent.path.corners[i + 1], Color.blue);
            }
        }
    }
}