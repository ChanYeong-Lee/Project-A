using System;
using System.Collections;
using UnityEngine;
using Random = UnityEngine.Random;

public class Moose : Monster
{
    [SerializeField] public State state;
    [SerializeField] public float time;

    /// <summary>
    ///  test
    /// </summary>
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
        Seat,
        Sleep
    }

    public override void Init()
    {
        base.Init();
        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Patrol, new PatrolState(this));
        stateMachine.AddState(State.Trace, new TraceState(this));
        stateMachine.AddState(State.Attack, new AttackState(this));
        stateMachine.AddState(State.Seat, new SeatState(this));
        stateMachine.AddState(State.Sleep, new SleepState(this));
        stateMachine.InitState(State.Idle);
        Debug.Log("init");
    }

    #region State

    private class MooseState : MonsterState
    {
        public Moose moose => owner as Moose;

        public MooseState(Creature owner) : base(owner) { }
    }

    private class IdleState : MooseState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            anim.SetBool("Stand", true);
        }

        public override void Update()
        {
            int IDInt = Random.Range(-1, 11);
            anim.SetInteger("IDInt", IDInt);

            // test
            moose.state = State.Idle;
        }

        public override void Transition()
        {
            if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime < 1f)
                return;

            // if (Random.Range(0, 2) == 1) 
            ChangeState(State.Seat);
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
            anim.SetBool("Stand", false);
            anim.SetFloat("Vertical", Random.Range(-1f, 3f));
            anim.SetFloat("Horizontal", Random.Range(-2f, 2f));
        }

        public override void Update()
        {
            // test
            moose.state = State.Patrol;
        }

        public override void Transition()
        {

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

    private class SeatState : MooseState
    {
        public SeatState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            anim.SetBool("Stand", true);
            anim.SetInteger("IDInt", -100);
        }

        public override void Update()
        {
            // test
            moose.state = State.Seat;
        }

        public override void Transition()
        {
            if (anim.GetCurrentAnimatorStateInfo(0).normalizedTime < 1f)
                return;

            // if (Random.Range(0, 2) == 1) 
            ChangeState(State.Sleep);
        }
    }

    private class SleepState : MooseState
    {
        public SleepState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            anim.SetInteger("IDInt", -101);
            moose.state = State.Sleep;

        }

        public override void Update()
        {
        }

        public override void Transition()
        {
            ChangeState(State.Idle);
        }

        public override void Exit()
        {
            anim.SetBool("Stand", false);
        }
    }

    #endregion
}