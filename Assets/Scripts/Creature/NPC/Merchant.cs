using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using static UnityEngine.Rendering.DebugUI;

public class Merchant : NPC
{
    [SerializeField] public State state;
    [SerializeField] private NavMeshAgent agent;

    public enum State
    {
        Idle,
        Wander,
        RunAway,
        Interact,
    }

   

    private void Update()
    {
        
    }


    public override void Init()
    {

        base.Init();
        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Wander, new WanderState(this));
        stateMachine.AddState(State.RunAway, new RnuAwayState(this));
        stateMachine.AddState(State.Interact, new InteractState(this));
        stateMachine.InitState(State.Idle);
        print("A");

        agent = GetComponent<NavMeshAgent>();

        moveSpeed = 3;
        sprintSpeed = 5;
        curSpeed = moveSpeed;

        agent.nextPosition = new Vector3(Random.Range(-10,10), 0, Random.Range(-10,10));
        agent.autoRepath = true;
    }

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

    #region State

    private class MerchantState : NPCState
    {
        protected Merchant merchant => owner as Merchant;
 
        public float CurSpeed
        {
            get { return merchant.CurSpeed; }
            set { merchant.CurSpeed = value; }
        }

        public MerchantState(Creature owner) : base(owner)  { }
    }

    private class IdleState : MerchantState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            Debug.Log("Idle Enter");
            ChangeState(State.Wander);
            

        }
        public override void Transition()
        {
           
        }
        public override void Exit()
        {
           
        }
    }

    private class WanderState : MerchantState
    { 
        public WanderState(Creature owner) : base(owner) { }
        public override void Enter()
        {
            Debug.Log("Wander Enter");
            CurSpeed = merchant.moveSpeed;
            merchant.SwitchAnimation(State.Wander, CurSpeed);

        }
        public override void Update()
        {
            Debug.Log("Wander Update");
            Move();
        }
        public override void Transition()
        {

        }

        private void Move()
        {
            owner.transform.Translate(Vector3.forward * CurSpeed * Time.deltaTime);
        }

    }

    private class RnuAwayState : MerchantState
    {
        public RnuAwayState(Creature owner) : base(owner) { }

        public override void Transition()
        {
            ChangeState(State.RunAway);
        }
        public override void Update()
        {

        }
    }

    private class InteractState : MerchantState
    {
        public InteractState(Creature owner) : base(owner) { }

        public override void Update()
        {
            CurSpeed = 0;
        }

        public override void Transition()
        {
            ChangeState(State.Interact);

        }
    }
    #endregion

}
