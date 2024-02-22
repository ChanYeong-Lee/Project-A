using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public abstract class Environment : MonoBehaviour, IFarmable
{
    [SerializeField] protected string envName;
    [SerializeField] protected bool isFarmable = true;
    [SerializeField] protected DropTableData dropItem;
    private IFarmable farmableImplementation;

    public string EnvName => envName;
    public bool IsFarmable => isFarmable;
    public DropTableData DropItem => dropItem;

    private void Start()
    {
        Init();
    }

    public virtual void Init()
    {
        if (dropItem == null) 
            isFarmable = false;
    }

    // TODO : 파밍 -> 오브젝트 삭제 -> 일정 시간 이후 재생성
    // TODO : 파밍 -> 드랍템 획득  

    public virtual Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType)
    {
        farmingType = Define.FarmingType.None;
        
        if (!isFarmable)
            return null;

        if (dropItem == null)
            return null;

        farmingType = dropItem.FarmingType;

        Managers.Pool.Push(gameObject);

        return dropItem.GetDropItem();
    }
}