using System;
using System.Collections;
using UnityEngine;
using Random = UnityEngine.Random;

public class Moose : Monster
{
    [SerializeField] private Transform eyes;
    [SerializeField] private Transform body;
    [SerializeField] private LayerMask layerMask;
    
    [SerializeField] public State state;
    [SerializeField] public float time;

    public enum State
    {
        Idle,
        Patrol,
        Run,
        TakeAttack,
        Trace,
        Attack,
    }

    public override void Init()
    {
        base.Init();
        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Patrol, new PatrolState(this));
        stateMachine.AddState(State.Run, new RunState(this));
        stateMachine.AddState(State.TakeAttack, new TakeAttackState(this));
        stateMachine.AddState(State.Trace, new TraceState(this));
        stateMachine.AddState(State.Attack, new AttackState(this));
        // stateMachine.InitState(State.Idle);
        stateMachine.InitState(State.Trace);
    }

    #region State

    private class MooseState : MonsterState
    {
        protected Moose moose => monster as Moose;
        protected bool isChangedState;
        protected bool isUnderAttack;
        protected float randTime;
        protected float vertical;
        protected float horizontal;
        protected int idInt;
        
        public MooseState(Creature owner) : base(owner) { }

        public override void Update()
        {
            randTime -= Time.deltaTime;

            // if (Physics.Raycast(moose.body.position, Vector3.down, out RaycastHit hit))
            // {
            //     Vector3 normal = hit.normal;
            //     Vector3.Angle(moose.GetComponent<Transform>().position, normal);
            // }
            
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
            horizontal = Random.Range(-2f, 2f);
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
            if (target != null && isUnderAttack) 
                ChangeState(State.Attack);
            
            if (Vector3.Distance(target.transform.position, moose.transform.position) < 10) 
                ChangeState(State.Run);
            
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
            
            Collider[] colliders = new Collider[1];
            int count = Physics.OverlapSphereNonAlloc(moose.eyes.position, 0.3f, colliders, moose.layerMask);

            if (count != 0)
                Turn();
            else
                Move();

            if (randTime < 0) 
                RandVariable(1f,2f, 0.3f);
        }

        public override void Transition()
        {
            base.Transition();
            
            // Idle
            if (isChangedState) 
                ChangeState(State.Idle);
        }

        private void Move()
        {
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
            anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), horizontal, Time.deltaTime));
        }
        
        private void Turn()
        {
            Debug.Log("turn");
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), 0, Time.deltaTime));
            anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.deltaTime));
        }
    }
    
    private class RunState : MooseState
    {
        public RunState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            vertical = 3;

            moose.state = State.Run;
        }

        public override void Update()
        {
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
            anim.SetFloat("Horizontal",
                Vector3.Dot(moose.transform.forward, moose.transform.position - target.transform.position) < 0
                    ? Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.deltaTime)
                    : Mathf.Lerp(anim.GetFloat("Horizontal"), 0, Time.deltaTime));
        }

        public override void Transition()
        {
            if (target == null || Vector3.Distance(target.transform.position, moose.transform.position) > 100)
            {
                ChangeState(State.Idle);
            }
        }
    }
    
    private class TakeAttackState : MooseState
    {
        public TakeAttackState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            anim.SetBool("Damaged", true);
        }

        public override void Update()
        {
            base.Update();
            
            // TODO : 대미지 받는 로직
            
        }

        public override void Transition()
        {
            ChangeState(Vector3.Distance(target.transform.position, moose.transform.position) < 3
                ? State.Attack
                : State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Damaged", false);
        }
    }
    
    private class TraceState : MooseState
    {
        public TraceState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            vertical = 3;

            moose.state = State.Trace;
        }

        public override void Update()
        {
            base.Update();
            
            anim.SetFloat("Vertical", Mathf.Lerp(anim.GetFloat("Vertical"), vertical, Time.deltaTime));
            // if (Vector3.Dot(moose.transform.forward, target.transform.position - moose.transform.position) > moose.transform.forward.magnitude * 0.9f)
            // {
            //     anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), 0, Time.deltaTime));
            // }
            // else
            // {
            //     float angle = Vector3.SignedAngle(moose.transform.forward,
            //         target.transform.position - moose.transform.position, Vector3.up);
            //
            //
            //     if (angle < 5 || angle > -5)
            //     {
            //         anim.SetFloat("Horizontal", 0);
            //     }
            //     else if (angle > 5)
            //     {
            //         anim.SetFloat("Horizontal", 2);
            //         Debug.Log($"각도 : {angle}");
            //     }
            //     else if (angle < -5)
            //     {
            //         anim.SetFloat("Horizontal", -2);
            //         Debug.Log($"각도 : {angle}");
            //     }
            // }
            
            float angle = Vector3.SignedAngle(moose.transform.forward,
                target.transform.position - moose.transform.position, Vector3.up);
            
            if (angle is < 5 and > -5)
            {
                anim.SetFloat("Horizontal",  Mathf.Lerp(anim.GetFloat("Horizontal"), 0, Time.deltaTime));
                Debug.Log($"각도 : {angle}");

            }
            else if (angle > 5)
            {
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), 2, Time.deltaTime));
                Debug.Log($"각도 : {angle}");
            }
            else if (angle < -5)
            {
                anim.SetFloat("Horizontal", Mathf.Lerp(anim.GetFloat("Horizontal"), -2, Time.deltaTime));
                Debug.Log($"각도 : {angle}");
            }
            
        }

        public override void Transition()
        {
            if (Vector3.Distance(target.transform.position, moose.transform.position) < 5) 
                ChangeState(State.Attack);
            
            if (Vector3.Distance(target.transform.position, moose.transform.position) > 100) 
                ChangeState(State.Patrol);
        }
    }
    
    private class AttackState : MooseState
    {
        public AttackState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            anim.SetBool("Attack", true);
            idInt = Random.Range(1, 4);
            anim.SetInteger("IDInt", idInt);
            // anim.SetBool("Attack", false);

            moose.state = State.Attack;
            Debug.Log("attack");
        }

        public override void Update()
        {
            base.Update();
            
            // TODO : 공격 로직
        }

        public override void Transition()
        {
            // if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime < 1f)
            //     return;
            
            if (target == null) 
                ChangeState(State.Idle);

            if (Vector3.Distance(target.transform.position, moose.transform.position) > 100) 
                ChangeState(State.Patrol);
            
            if (Vector3.Distance(target.transform.position, moose.transform.position) > 3) 
                ChangeState(State.Trace);
        }

        public override void Exit()
        {
            anim.SetBool("Attack", false);
        }
    }
    
    #endregion
}