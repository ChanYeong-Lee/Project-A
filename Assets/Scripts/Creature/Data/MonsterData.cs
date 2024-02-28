using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New Monster Data", menuName = "ScriptableObject/Creature Data/Monster Data")]
public class MonsterData : CreatureData
{
    [Header("Monster Info")]
    [Tooltip("공격 쿨타임")]
    [SerializeField] private float attackCooldown;
    [Tooltip("드랍 아이템 테이블 데이터")] 
    [SerializeField] private DropTableData dropItem;
    [Tooltip("드랍 경험치")]
    [SerializeField] private List<int> dropExpList;

    public float AttackCooldown => attackCooldown;
    public DropTableData DropItem => dropItem;
    public List<int> DropExpList
    {
        get
        {
            if (dropExpList.Count >= stats.Count) 
                return dropExpList;
            
            for (int i = 0; i < stats.Count - dropExpList.Count; i++) 
                dropExpList.Add(dropExpList[^1]);
            
            return dropExpList;
        }
    }
}