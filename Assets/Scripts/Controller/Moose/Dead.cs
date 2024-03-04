using State = Define.MooseState;

namespace MooseController
{
    public class DeadState : MooseState
    {
        public DeadState(Creature owner) : base(owner) { }

        public override void Enter()
        {
            moose.IsFarmable = true;

            anim.SetTrigger("Death");
            // anim.SetBool("Death", true);
            moose.state = State.Dead;
        
            // TODO : 경험치 획득 - 
            target.GetComponent<Player>().Exp += moose.Data.DropExpList[moose.CurrentLevel];
        }

        public override void Update() { }

        public override void FixedUpdate() { }
    }
}
