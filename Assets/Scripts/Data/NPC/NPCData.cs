using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "New NPC Data", menuName = "ScriptableObject/NPC Data/NPC Data")]

public class NPCData : ScriptableObject
{
    [Header("NPC Info")]
    [SerializeField] protected string npcName;
    [SerializeField] protected List<Stat> inven;

    public NPCStat npcStat;

    public string NPCName => npcName;
    public List<Stat> Inven => inven;
}

[Serializable]
public class NPCStat
{
    [Tooltip("이동속도")][SerializeField] private float moveSpeed;
    [Tooltip("달리기속도")][SerializeField] private float sprintSpeed;

    public float MoveSpeed { get => moveSpeed; set => moveSpeed = value; }
    
    public float SprintSpeed { get => sprintSpeed; set => sprintSpeed = value; }
}