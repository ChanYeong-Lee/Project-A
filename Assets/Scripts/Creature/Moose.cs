public class Moose : Monster
{
    public enum State
    {
        Idle,
        Wander,
        Trace,
        Attack,
    }
    
    public override void Init()
    {
        base.Init();
        stateMachine.AddState(State.Idle, new MooseState(this));
        stateMachine.AddState(State.Wander, new MooseState(this));
        stateMachine.AddState(State.Trace, new MooseState(this));
        stateMachine.AddState(State.Attack, new MooseState(this));
        stateMachine.InitState(State.Idle);
    }

    #region State

    private class MooseState : MonsterState
    {
        public MooseState(Creature owner) : base(owner) { }
    }
    
    private class IdleState : MooseState
    {
        public IdleState(Creature owner) : base(owner) { }

        public override void Transition()
        {
            
        }
    }

    private class WanderState : MooseState
    {
        public WanderState(Creature owner) : base(owner) { }
        
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
    
    #endregion
}