using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New Monster Data", menuName = "ScriptableObject/Creature Data/Monster Data")]
public class MonsterData : CreatureData
{
    [Header("Monster Info")] 
    [Tooltip("공격 범위")]
    [SerializeField] private float attackRange;
    [Tooltip("공격 쿨타임")]
    [SerializeField] private float attackCooldown;
    [Tooltip("공격 성향")]
    [SerializeField] private bool isAggressive;
    [Tooltip("시야 거리")] 
    [SerializeField] private float viewDistance;
    [Tooltip("추적 거리")] 
    [SerializeField] private float trackingDistance;
    [Tooltip("드랍 아이템 테이블 데이터")] 
    [SerializeField] private DropTableData dropItem;
    [Tooltip("드랍 경험치")]
    [SerializeField] private List<int> dropExpList;

    public float AttackRange => attackRange;
    public float AttackCooldown => attackCooldown;
    public bool IsAggressive => isAggressive;
    public float ViewDistance => viewDistance;
    public float TrackingDistance => trackingDistance;
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