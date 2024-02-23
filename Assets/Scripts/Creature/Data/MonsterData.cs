using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New Monster Data", menuName = "ScriptableObject/Creature Data/Monster Data")]
public class MonsterData : CreatureData
{
    [Header("Monster Info")]
    [Tooltip("이동 속도")] 
    [SerializeField] private float moveSpeed;
    [Tooltip("드랍 아이템 테이블 데이터")] 
    [SerializeField] private DropTableData dropItem;
    [Tooltip("드랍 경험치")]
    [SerializeField] private List<int> dropExpList;

    public float MoveSpeed => moveSpeed;
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