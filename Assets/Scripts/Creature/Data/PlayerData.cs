using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New Player Data", menuName = "ScriptableObject/Creature Data/Player Data")]
public class PlayerData : CreatureData
{
    [Header("Player Info")] 
    [SerializeField] private float farmingTime;
    [SerializeField] private List<int> expList;

    public float FarmingTime => farmingTime;
    public List<int> ExpList
    {
        get
        {
            if (expList.Count >= stats.Count) 
                return expList;
            
            for (int i = 0; i < stats.Count - expList.Count; i++) 
                expList.Add(expList[^1]);
            
            return expList;
        }
    }
}