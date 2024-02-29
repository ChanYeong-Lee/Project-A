using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New NPC Data", menuName = "ScriptableObject/Creature Data/NPC Data")]
public class NPCData : CreatureData
{
    [Header("NPC Info")]
    [SerializeField] protected float moveSpeed;
    [SerializeField] protected float sprintSpeed;

}
