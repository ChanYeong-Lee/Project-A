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

    // TODO : �Ĺ� -> ������Ʈ ���� -> ���� �ð� ���� �����
    // TODO : �Ĺ� -> ����� ȹ��  
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