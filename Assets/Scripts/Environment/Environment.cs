using System;
using System.Collections.Generic;
using UnityEngine;

public abstract class Environment : MonoBehaviour, IFarmable
{
    [SerializeField] protected string envName;
    [SerializeField] protected bool isFarmable;
    [SerializeField] protected List<Item> dropItemList;
    
    public string EnvName => envName;
    public bool IsFarmable => isFarmable;
    public List<Item> DropItemList { get => dropItemList; set => dropItemList = value; }
    
    public virtual void Init()
    {
        
    }

    // TODO : 파밍 -> 오브젝트 삭제 -> 일정 시간 이후 재생성
    // TODO : 파밍 -> 드랍템 획득  
    
    public virtual void Farming()
    {
        
    }
}