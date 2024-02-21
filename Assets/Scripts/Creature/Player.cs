public class Player : Creature
{
    private int _exp;
    
    public int Exp { get => _exp; set => _exp = value; }

    public override void Init()
    {
        base.Init();
        
    }
}