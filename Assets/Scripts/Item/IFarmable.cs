using System.Collections.Generic;

public interface IFarmable
{
    public List<Item> DropItemList { get; set; }

    public void Farming();
}