public class Player : Creature
{
    private PlayerData data;
    private int _exp;

    public PlayerData Data => data; 
    public int Exp { get => _exp; set => _exp = value; }

    public override void Init()
    {
        base.Init();
        
    }
}