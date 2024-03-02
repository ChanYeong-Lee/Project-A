using MooseController;

public class DeadState : MooseState
{
    public DeadState(Creature owner) : base(owner) { }

    public override void Enter()
    {
        moose.IsFarmable = true;

        anim.SetBool("Death", true);
        
        // TODO : 경험치 획득
    }
    
    
}