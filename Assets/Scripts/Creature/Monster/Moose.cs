﻿using System;
using System.Collections;
using UnityEngine;
using Random = UnityEngine.Random;
using MooseController;
using UnityEngine.Serialization;
using State = Define.MooseState;

public class Moose : Monster
{
    [SerializeField] private Transform eyes;
    [SerializeField] private Transform body;
    [SerializeField] private LayerMask detection;
    
    // 인스펙터 확인용
    public State state;
    public float distance;
    public float angle;

    public Transform Eyes => eyes;
    public Transform Body => body;
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
        stateMachine.AddState(State.Dead, new DeadState(this));
        stateMachine.InitState(State.Idle);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Arrow"))
        {
            stateMachine.ChangeState(State.TakeAttack);
        }
    }
}