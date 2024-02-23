using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class Environment : MonoBehaviour, IFarmable
{
    [SerializeField] protected EnvironmentData envData;

    public EnvironmentData EnvData => envData;
    
    private void Start()
    {
        Init();
    }

    public virtual void Init()
    {
    }

    // TODO : 파밍 -> 오브젝트 삭제 -> 일정 시간 이후 재생성
    // TODO : 파밍 -> 드랍템 획득  
    public virtual Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType)
    {
        farmingType = Define.FarmingType.None;
        
        if (!envData.IsFarmable)
            return null;

        if (envData.DropItem == null)
            return null;

        farmingType = envData.DropItem.FarmingType;
        
        return envData.DropItem.GetDropItem();
    }
}