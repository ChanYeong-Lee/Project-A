using System;
using System.Collections;
using UnityEngine;
using Random = UnityEngine.Random;

public class Moose : Monster
{
    [SerializeField] public State state;
    [SerializeField] public float time;
    
    private void Update()
    {
        time = anim.GetCurrentAnimatorStateInfo(0).normalizedTime;
    }

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
        protected float randTime;
        protected float vertical;
        protected float horizontal;
        protected bool isStand;
        protected int idInt;
        
        public MooseState(Creature owner) : base(owner) { }

        public override void Update()
        {
            randTime -= Time.deltaTime;
            if (randTime < 0) 
                RandVariable();
        }

        // 랜덤 값 생성
        // TODO : 패트롤일 때 달리기보다 옆으로 돌기만 해서 수치 조정 필요
        protected void RandVariable()
        {
            randTime = Random.Range(1f, 10f);
            isStand = Random.value > 0.5f;
            vertical = Random.Range(-1f, 3f);
            horizontal = Random.Range(-2f, 2f);
            idInt = Random.Range(-1, 11);
        }
    }
    
    private class IdleState : MooseState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            anim.SetBool("Stand", true);
            
            moose.state = State.Idle;
        }
        
        public override void Update()
        {
            base.Update();
            
            anim.SetInteger("IDInt", idInt);
        }

        public override void Transition()
        {
            if (isStand && anim.IsInTransition(0)) 
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
            RandVariable();
            
            anim.SetBool("Stand", false);
            
            moose.state = State.Patrol;
        }

        public override void Update()
        {
            base.Update();
            
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
            anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), horizontal, Time.deltaTime));
        }

        public override void Transition()
        {
            if (isStand)
            {
                ChangeState(State.Idle);
                Debug.Log("stand");
            }
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