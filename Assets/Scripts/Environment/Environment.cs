using System;
using System.Collections.Generic;
using UnityEngine;

public abstract class Environment : MonoBehaviour, IFarmable
{
    [SerializeField] protected string envName;
    [SerializeField] protected bool isFarmable = true;
    [SerializeField] protected List<ItemData> dropItemList;
    
    public string EnvName => envName;
    public bool IsFarmable => isFarmable;
    public List<ItemData> DropItemList => dropItemList;

    private void Start()
    {
        Init();
    }

    public virtual void Init()
    {
    }

    // TODO : 파밍 -> 오브젝트 삭제 -> 일정 시간 이후 재생성
    // TODO : 파밍 -> 드랍템 획득  
    
    public virtual (ItemData, int) Farming()
    {
        if (!isFarmable)
            return (null, 0);
        
        Debug.Log($"{envName}");

        Managers.Pool.Push(gameObject);

        return (dropItemList[0], 1);
    }
}