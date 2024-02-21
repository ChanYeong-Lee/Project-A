using System.Collections.Generic;
using UnityEngine;

public abstract class Monster : Creature, IFarmable
{
    [SerializeField] protected List<Item> dropItem;
    
    public List<Item> DropItemList { get => dropItem; set => dropItem = value; }
    
    
    public override void Init()
    {
        base.Init();
    }


    public void Farming()
    {
        // 캐릭터 인벤에 드롭아이템 추가
    }
}