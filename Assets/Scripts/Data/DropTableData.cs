using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New Drop Data", menuName = "ScriptableObject/Drop Data", order = 0)]
public class DropTableData : ScriptableObject
{
    [Header("Drop Info")] 
    [SerializeField] private int id;
    [SerializeField] private Define.FarmingType farmingType;
    [Tooltip("드랍 아이템 리스트")]
    [SerializeField] private List<FarmingItemData> dropItemList;
    [Tooltip("드랍 아이템 최소 개수")]
    [SerializeField] private List<int> dropItemMinCount;
    [Tooltip("드랍 아이템 최대 개수")]
    [SerializeField] private List<int> dropItemMaxCount;
    [Tooltip("드랍 아이템 확률")]
    [SerializeField] private List<int> dropItemRate;
        
    public int ID => id;
    public Define.FarmingType FarmingType => farmingType;

    public List<int> DropItemCount
    {
        get
        {
            List<int> dropItemCount = new List<int>();
            for (int i = 0; i < dropItemList.Count; i++) 
                dropItemCount.Add(Random.Range(dropItemMinCount[i], dropItemMaxCount[i] + 1));
                
            return dropItemCount;
        }
    }

    public Dictionary<FarmingItemData, int> GetDropItem()
    {
        Dictionary<FarmingItemData, int> dictionary = new Dictionary<FarmingItemData, int>();
        
        for (int i = 0; i < dropItemList.Count; i++)
        {
            float rand = Random.Range(1.0f, 100.0f);

            if (rand <= dropItemRate[i]) 
                dictionary.Add(dropItemList[i], DropItemCount[i]);
        }

        return dictionary;
    }
}