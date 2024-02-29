using System;
using System.Collections;
using UnityEngine;
using Random = UnityEngine.Random;
using MooseController;
using UnityEngine.Serialization;
using State = Define.MooseState;

public class Moose : Monster
{
    [SerializeField] private Transform eyes;
    [SerializeField] private LayerMask detection;
    
    // 인스펙터 확인용
    public State state;
    public float distance;

    public Transform Eyes => eyes;
    public LayerMask Detection => detection;

    public override void Init()
    {
        base.Init();
        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Patrol, new PatrolState(this));
        stateMachine.AddState(State.Run, new RunState(this));
        stateMachine.AddState(State.TakeAttack, new TakeAttackState(this));
        stateMachine.AddState(State.Trace, new TraceState(this));
        stateMachine.AddState(State.Attack, new AttackState(this));
        stateMachine.InitState(State.Idle);
    }
}