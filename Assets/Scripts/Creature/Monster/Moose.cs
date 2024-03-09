using System;
using System.Collections;
using System.Collections.Generic;
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
    [SerializeField] private AttackPoint attackPoint;
    
    private int receivedDamage;
    
    // 인스펙터 확인용
    public State state;
    public float distance;
    public float angle;
    
    public Transform Eyes => eyes;
    public Transform Body => body;
    public LayerMask Detection => detection;
    public int ReceivedDamage => receivedDamage;

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
        GetComponentInChildren<AttackPoint>().gameObject.SetActive(true);
    }
    
    public override Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType)
    {
        Debug.Log("파밍 중");
        return base.Farming(out farmingType);
    }

    public override void TakeDamage(ArrowData arrowData, AttackPointType a)
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

    public override void ReSpawn()
    {
        stateMachine.InitState(State.Idle);
        attackPoint.gameObject.SetActive(true);
        currentStat = new Stat(creatureData.Stats.Find(stat => stat.Level == currentLevel));
    }
}