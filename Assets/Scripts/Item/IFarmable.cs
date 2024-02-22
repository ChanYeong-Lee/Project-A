using System.Collections.Generic;
using UnityEngine;

public interface IFarmable
{
    public DropTableData DropItem { get; }

    public Dictionary<FarmingItemData, int> Farming(out Define.FarmingType farmingType);
}