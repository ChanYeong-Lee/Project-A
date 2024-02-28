using System;
using System.Collections.Generic;
using UnityEngine;

public class StateMachine : MonoBehaviour
{
    private Dictionary<string, BaseState> stateDic = new Dictionary<string, BaseState>();
    private BaseState currentState;

    private void Start()
    {
        currentState.Enter();
    }

    private void Update()
    {
        currentState.Update();
        currentState.Transition();
    }

    private void FixedUpdate()
    {
        currentState.FixedUpdate();
    }

    public void InitState(string stateName)
    {
        currentState = stateDic[stateName];
    }

    public void AddState(string stateName, BaseState state)
    {
        state.StateMachine = this;
        stateDic.Add(stateName, state);
    }

    public void ChangeState(string stateName)
    {
        currentState.Exit();
        currentState = stateDic[stateName];
        currentState.Enter();
    }

    public void InitState<T>(T stateType) where T : Enum
    {
        InitState(stateType.ToString());
    }

    public void AddState<T>(T stateType, BaseState state) where T : Enum
    {
        AddState(stateType.ToString(), state);
    }

    public void ChangeState<T>(T stateType) where T : Enum
    {
        ChangeState(stateType.ToString());
    }
}

public abstract class BaseState
{
    private StateMachine stateMachine;

    public StateMachine StateMachine
    {
        set => stateMachine = value;
    }

    protected void ChangeState(string stateName)
    {
        stateMachine.ChangeState(stateName);
    }

    protected void ChangeState<T>(T stateType) where T : Enum
    {
        ChangeState(stateType.ToString());
    }
    
    public virtual void Enter()
    {
    }

    public virtual void Update()
    {
    }

    public virtual void FixedUpdate()
    {
    }
    
    public virtual void Exit()
    {
    }

    public virtual void Transition()
    {
    }
}