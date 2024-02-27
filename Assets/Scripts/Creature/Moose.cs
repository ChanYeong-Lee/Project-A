using System;
using System.Collections;
using UnityEngine;
using Random = UnityEngine.Random;

public class Moose : Monster
{
    [SerializeField] public State state;
    [SerializeField] public float time;

    public enum State
    {
        Idle,
        Patrol,
        Trace,
        Attack,
    }
    
    public override void Init()
    {
        base.Init();
        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Patrol, new PatrolState(this));
        stateMachine.AddState(State.Trace, new TraceState(this));
        stateMachine.AddState(State.Attack, new AttackState(this));
        stateMachine.InitState(State.Idle);
    }

    #region State

    private class MooseState : MonsterState
    {
        protected Moose moose => owner as Moose;
        protected bool isChangedState;
        protected float randTime;
        protected float vertical;
        protected float horizontal;
        protected int idInt;
        
        public MooseState(Creature owner) : base(owner) { }

        public override void Update()
        {
            randTime -= Time.deltaTime;
            
            // 인스펙터 확인용 코드
            moose.time = randTime;
        }

        // 랜덤 값 생성
        // 랜덤 수치 값 일부 조정 가능한 함수(최소 시간, 최대 시간, 상태 머신 바뀔 확률)
        protected void RandVariable(float minTime = 1f, float maxTime = 10f, float rateToChange = 0.5f)
        {
            randTime = Random.Range(minTime, maxTime);
            isChangedState = Random.value < rateToChange;
            vertical = Random.Range(-1f, 5f);
            horizontal = Random.Range(-2f, 2f) * Random.value;
            idInt = Random.Range(-1, 11);
        }
    }
    
    private class IdleState : MooseState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            // 인스펙터 확인용 코드
            moose.state = State.Idle;

            RandVariable(1f, 5f, 0);
            anim.SetBool("Stand", true);
            Debug.Log("IDLE");
        }
        
        public override void Update()
        {
            base.Update();

            anim.SetInteger("IDInt", idInt);
            
            
            if (randTime < 0) 
                RandVariable(1f,2f, 0.9f);
        }

        public override void Transition()
        {
            if (isChangedState) 
                ChangeState(State.Patrol);
        }

        public override void Exit()
        {
            anim.SetBool("Stand", false);
        }
    }
    
    private class PatrolState : MooseState
    {
        public PatrolState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            // 인스펙터 확인용 코드
            moose.state = State.Patrol;
            
            RandVariable(1f, 5f, 0);

            anim.SetBool("Stand", false);
        }

        public override void Update()
        {
            base.Update();
            
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
            anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), horizontal, Time.deltaTime));
            
            if (randTime < 0) 
                RandVariable(1f,2f, 0.3f);
        }

        public override void Transition()
        {
            if (isChangedState) 
                ChangeState(State.Idle);
        }
    }
    
    private class TraceState : MooseState
    {
        public TraceState(Creature owner) : base(owner) { }
            
        public override void Transition()
        {
        }
    }
    
    private class AttackState : MooseState
    {
        public AttackState(Creature owner) : base(owner) { }
            
        public override void Transition()
        {
        }
    }
    
    #endregion
}