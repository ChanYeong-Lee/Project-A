using System.Buffers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Merchant : NPC
{
    [SerializeField] private Animator animator;

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
        animator = GetComponent<Animator>();

        base.Init();
        stateMachine.AddState(State.Idle, new MerchantState(this));
        stateMachine.AddState(State.Wander, new MerchantState(this));
        stateMachine.AddState(State.RunAway, new MerchantState(this));
        stateMachine.AddState(State.Interact, new MerchantState(this));
        stateMachine.InitState(State.Idle);
        print("A");

        

        moveSpeed = 3;
        sprintSpeed = 5;
        curSpeed = moveSpeed;
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
            CurSpeed = merchant.moveSpeed;
            
        }
        public override void Update()
        {
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
