using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

public class Environment : MonoBehaviour, IFarmable
{
    [SerializeField] protected EnvironmentData envData;
    [SerializeField] private bool isFarmable;

    public EnvironmentData EnvData => envData;

    public bool IsFarmable { get => isFarmable; set => isFarmable = value; }
    
    private void Start()
    {
        Init();
    }

    public virtual void Init()
    {
        if (envData == null) 
            isFarmable = false;
    }

    // TODO : 파밍 -> 오브젝트 삭제 -> 일정 시간 이후 재생성
    // TODO : 파밍 -> 드랍템 획득  
    public virtual Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType)
    {
        farmingType = Define.FarmingType.None;
        
        if (!isFarmable)
            return null;

        if (envData.DropItem == null)
            return null;

        farmingType = envData.DropItem.FarmingType;
        
        return envData.DropItem.GetDropItem();
    }
}