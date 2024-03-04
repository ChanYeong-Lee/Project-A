using State = Define.BearState;

namespace BearController
{
    public class DeadState : BearState
    {
        public DeadState(Creature owner) : base(owner) { }
        
        public override void Enter()
        {
            bear.IsFarmable = true;

            anim.SetTrigger("Death");
            // anim.SetBool("Death", true);
            bear.state = State.Dead;
        
            // TODO : °æÇèÄ¡ È¹µæ - 
            // target.GetComponent<Player>().Exp += moose.Data.DropExpList[moose.CurrentLevel];
        }

        public override void Update() { }

        public override void FixedUpdate() { }
    }
}