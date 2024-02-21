using UnityEngine;

public abstract class Monster : Creature, IFarmable
{
    protected GameObject drop;
    
    public GameObject Drop { get => drop; set => drop = value; }
    
    
    public override void Init()
    {
        base.Init();
    }

    public void Farming()
    {
        // 캐릭터 인벤에 드롭아이템 추가
    }
}