using System.Collections.Generic;

public interface IFarmable
{
    public List<ItemData> DropItemList { get; }

    public (ItemData, int) Farming();
}