using System.Collections.Generic;
using UnityEngine;

public class Tree : Environment
{
    private void Start()
    {
    }

    public override void Init()
    {
        if (string.IsNullOrEmpty(envName)) 
            envName = "나무";
    }
    
    public override Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType)
    {
        return base.Farming(out farmingType);
    }
}